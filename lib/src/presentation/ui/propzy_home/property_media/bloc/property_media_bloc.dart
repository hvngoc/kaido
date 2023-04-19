import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_home_upload_file_request.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/models/propzy_home_media_model.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'property_media_event.dart';

part 'property_media_state.dart';

class PropertyMediaBloc extends Bloc<PropertyMediaEvent, PropertyMediaState> {
  final uploadFileUseCase = GetIt.I.get<UploadFileUseCase>();
  final deleteFileUseCase = GetIt.I.get<DeleteFileUseCase>();
  final getListCaptionUseCase = GetIt.I.get<GetListCaptionUseCase>();
  final updateCaptionFileUseCase = GetIt.I.get<UpdateCaptionFileUseCase>();
  final prefHelper = GetIt.I.get<PrefHelper>();

  PropertyMediaBloc({required this.offerId, required this.typeSource})
      : super(PropertyMediaInitial()) {
    on<PropertyMediaGetOfferEvent>(_getOfferDetail);
    on<PropertyMediaCaptureImageEvent>(_captureImage);
    on<PropertyMediaSelectFromAlbumEvent>(_selectFromAlbum);
    on<PropertyMediaUploadFilesEvent>(_uploadFiles);
    on<PropertyMediaDeleteFileEvent>(_deleteFile);
    on<PropertyMediaGetListCaptionEvent>(_getListCaption);
    on<PropertyMediaSelectCaptionEvent>(_selectCaption);
    on<PropertyMediaTimerEndEvent>(_timerEnd);
  }

  final int offerId;
  final int typeSource;
  List<AssetEntity> selectedAssets = [];
  List<PropzyHomeMediaAssetModel> listAssets = [];
  List<HomeCaptionMediaModel> listCaptions = [];
  String errorString = '';

  final listVideoFormats = ['video/mp4', 'video/quicktime'];
  final listImageFormats = ['image/jpeg', 'image/jpg', 'image/png', 'image/heic'];

  FutureOr<void> _timerEnd(
    PropertyMediaTimerEndEvent event,
    Emitter<PropertyMediaState> emitter,
  ) {
    emitter(PropertyMediaInitial());
    errorString = '';
    emitter(PropertyMediaCaptureImageSuccess());
  }

  FutureOr<void> _getListCaption(
    PropertyMediaGetListCaptionEvent event,
    Emitter<PropertyMediaState> emitter,
  ) async {
    emitter(PropertyMediaInitial());
    final response = await getListCaptionUseCase.call(null);
    response.fold(
      (l) => emitter(PropertyMediaFail()),
      (r) {
        listCaptions = r ?? [];
        emitter(PropertyMediaGetListCaptionSuccess());
      },
    );
  }

  FutureOr<void> _getOfferDetail(
    PropertyMediaGetOfferEvent event,
    Emitter<PropertyMediaState> emit,
  ) async {
    _mapFromOfferDetail(event.offerModel);
    emit(PropertyMediaGetOfferSuccess());
  }

  bool validateMinAssets() {
    final listImages =
        listAssets.where((element) => element.typeFile == Constants.MEDIA_FILE_TYPE_IMAGE);
    return listImages.length >= Constants.MIN_NUM_IMAGES_MEDIA;
  }

  void _mapFromOfferDetail(HomeOfferModel? offerModel) {
    listAssets.clear();
    selectedAssets.clear();
    final files = offerModel?.files ?? [];
    var filterredFiles = files
        .where((file) => (file.typeSource ?? Constants.MEDIA_SOURCE_TYPE_MEDIA) == typeSource)
        .toList();

    if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
      filterredFiles.sort((file1, file2) {
        return (file2.typeFile ?? Constants.MEDIA_FILE_TYPE_IMAGE) -
            (file1.typeFile ?? Constants.MEDIA_FILE_TYPE_IMAGE);
      });
    }

    if (filterredFiles.length > 0) {
      final initialList = filterredFiles
          .map(
            (e) => PropzyHomeMediaAssetModel(
              file: e,
              typeSource: typeSource,
              typeFile: e.typeFile ?? Constants.MEDIA_FILE_TYPE_IMAGE,
              caption: e.caption,
              isUploadSuccess: true,
            ),
          )
          .toList();
      listAssets = initialList;
    }
  }

  FutureOr<void> _captureImage(
    PropertyMediaCaptureImageEvent event,
    Emitter<PropertyMediaState> emit,
  ) async {
    emit(PropertyMediaInitial());
    final entity = event.assetEntity;

    var isExceedSize = false;
    var isWrongFormat = false;
    final assetBytes = await entity.originBytes;
    final mimeType = (await entity.mimeTypeAsync ?? 'null').toLowerCase();
    final sizeMB = (assetBytes?.length ?? 0) / 1024 / 1024;
    if (entity.type == AssetType.video) {
      if (sizeMB > 50) {
        isExceedSize = true;
      } else if (!listVideoFormats.contains(mimeType)) {
        isWrongFormat = true;
      }
    } else if (entity.type == AssetType.image) {
      if (sizeMB > 5) {
        isExceedSize = true;
      } else if (!listImageFormats.contains(mimeType)) {
        isWrongFormat = true;
      }
    }

    if (isExceedSize) {
      if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
        errorString = 'Quý khách chỉ được đăng tải tối đa 5M/hình, 50M/video.';
      } else {
        errorString = 'Quý khách chỉ được đăng tải tối đa 5M/hình.';
      }
      emit(PropertyMediaStartTimerState());
      return;
    }

    if (isWrongFormat) {
      if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
        errorString = 'Quý khách chỉ được đăng tải định dạng JPG, JPEG, PNG, HEIC, MOV hoặc MP4.';
      } else {
        errorString = 'Quý khách chỉ được đăng tải định dạng JPG, JPEG, PNG, HEIC.';
      }
      emit(PropertyMediaStartTimerState());
      return;
    }

    final maxLimitImages = typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA
        ? Constants.MAX_NUM_IMAGES_MEDIA
        : Constants.MAX_NUM_IMAGES_LEGAL;
    final maxLimitVideos = Constants.MAX_NUM_VIDEOS_MEDIA;
    final listImages =
        listAssets.where((element) => element.typeFile == Constants.MEDIA_FILE_TYPE_IMAGE);
    final listVideos =
        listAssets.where((element) => element.typeFile == Constants.MEDIA_FILE_TYPE_VIDEO);

    if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA && entity.type == AssetType.video) {
      if (listVideos.length < maxLimitVideos) {
        errorString = '';
        var lastVideoIndex = listAssets
            .lastIndexWhere((element) => element.typeFile == Constants.MEDIA_FILE_TYPE_VIDEO);
        final newAsset = PropzyHomeMediaAssetModel(
          assetEntity: entity,
          typeSource: typeSource,
          typeFile: entity.type == AssetType.video
              ? Constants.MEDIA_FILE_TYPE_VIDEO
              : Constants.MEDIA_FILE_TYPE_IMAGE,
          isUploadSuccess: false,
        );
        listAssets.insert(lastVideoIndex + 1, newAsset);
        selectedAssets.add(entity);
        emit(PropertyMediaCaptureImageSuccess());
      } else {
        errorString =
            'Quý khách chỉ có thể đăng tải tối đa thêm ${maxLimitImages - listImages.length} hình, 0 video.';
        emit(PropertyMediaStartTimerState());
      }
    } else {
      if (listImages.length < maxLimitImages) {
        errorString = '';
        listAssets.add(
          PropzyHomeMediaAssetModel(
            assetEntity: entity,
            typeSource: typeSource,
            typeFile: entity.type == AssetType.video
                ? Constants.MEDIA_FILE_TYPE_VIDEO
                : Constants.MEDIA_FILE_TYPE_IMAGE,
            isUploadSuccess: false,
          ),
        );
        selectedAssets.add(entity);
        emit(PropertyMediaCaptureImageSuccess());
      } else {
        if (typeSource == Constants.MEDIA_SOURCE_TYPE_LEGAL) {
          errorString =
              'Quý khách chỉ có thể đăng tải tối đa thêm 0 hình, ${maxLimitVideos - listVideos.length} video.';
        } else {
          errorString = 'Quý khách chỉ có thể đăng tải tối đa thêm 0 hình.';
        }
        emit(PropertyMediaStartTimerState());
      }
    }
  }

  FutureOr<void> _selectFromAlbum(
    PropertyMediaSelectFromAlbumEvent event,
    Emitter<PropertyMediaState> emit,
  ) async {
    final results1 = event.pickedAssets;
    List<AssetEntity> results = [];
    if (results1 != null) {
      emit(PropertyMediaInitial());
      var isExceedSize = false;
      var isWrongFormat = false;
      for (AssetEntity assetEntity in results1) {
        final assetBytes = await assetEntity.originBytes;
        var mimeType = (await assetEntity.mimeTypeAsync ?? 'null').toLowerCase();
        if (Platform.isIOS) {
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          var iosInfo = await deviceInfo.iosInfo;
          if (!iosInfo.isPhysicalDevice) {
            mimeType = 'image/jpeg';  //Fix for ios simulator return mimeType null
          }
        }

        final sizeMB = (assetBytes?.length ?? 0) / 1024 / 1024;
        if (assetEntity.type == AssetType.video) {
          if (sizeMB > 50) {
            isExceedSize = true;
          } else if (!listVideoFormats.contains(mimeType)) {
            isWrongFormat = true;
          } else {
            results.add(assetEntity);
          }
        } else if (assetEntity.type == AssetType.image) {
          if (sizeMB > 5) {
            isExceedSize = true;
          } else if (!listImageFormats.contains(mimeType)) {
            isWrongFormat = true;
          } else {
            results.add(assetEntity);
          }
        } else {
          results.add(assetEntity);
        }
      }

      var tmpList = listAssets.where((element) => element.isFileModel).toList();

      final maxLimitImages = typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA
          ? Constants.MAX_NUM_IMAGES_MEDIA
          : Constants.MAX_NUM_IMAGES_LEGAL;
      final maxLimitVideos = Constants.MAX_NUM_VIDEOS_MEDIA;

      var numVideoExceed = 0;
      if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
        final listUploadedVideos = tmpList
            .where((element) => element.typeFile == Constants.MEDIA_FILE_TYPE_VIDEO)
            .toList();
        var listVideos = results.where((element) => element.type == AssetType.video).toList();
        numVideoExceed = listUploadedVideos.length + listVideos.length - maxLimitVideos;
        if (numVideoExceed > 0) {
          for (int i = 0; i < numVideoExceed; i++) {
            final asset = listVideos.removeLast();
            results.remove(asset);
          }
        }
      }

      final listUploadedImages =
          tmpList.where((element) => element.typeFile == Constants.MEDIA_FILE_TYPE_IMAGE).toList();
      var listImages = results.where((element) => element.type == AssetType.image).toList();
      final numImagesExceed = listUploadedImages.length + listImages.length - maxLimitImages;
      if (numImagesExceed > 0) {
        for (int i = 0; i < numImagesExceed; i++) {
          final asset = listImages.removeLast();
          results.remove(asset);
        }
      }

      for (AssetEntity asset in results) {
        final foundedAsset = listAssets.firstWhere((element) => element.assetEntity == asset,
            orElse: () => PropzyHomeMediaAssetModel());
        tmpList.add(
          PropzyHomeMediaAssetModel(
            assetEntity: asset,
            typeSource: typeSource,
            typeFile: asset.type == AssetType.video
                ? Constants.MEDIA_FILE_TYPE_VIDEO
                : Constants.MEDIA_FILE_TYPE_IMAGE,
            caption: foundedAsset.isNull ? null : foundedAsset.caption,
            isUploadSuccess: foundedAsset.isNull ? false : foundedAsset.isUploadSuccess,
          ),
        );
      }

      if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
        tmpList.sort((asset1, asset2) {
          return asset2.typeFile - asset1.typeFile;
        });
      }

      selectedAssets = results;
      listAssets = tmpList;

      if (isExceedSize) {
        if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
          errorString = 'Quý khách chỉ được đăng tải tối đa 5M/hình, 50M/video.';
        } else {
          errorString = 'Quý khách chỉ được đăng tải tối đa 5M/hình.';
        }
        emit(PropertyMediaStartTimerState());
        return;
      }

      if (isWrongFormat) {
        if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
          errorString = 'Quý khách chỉ được đăng tải định dạng JPG, JPEG, PNG, HEIC, MOV hoặc MP4.';
        } else {
          errorString = 'Quý khách chỉ được đăng tải định dạng JPG, JPEG, PNG, HEIC.';
        }
        emit(PropertyMediaStartTimerState());
        return;
      }

      if (numImagesExceed > 0 || numVideoExceed > 0) {
        if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
          errorString =
              'Quý khách chỉ có thể đăng tải tối đa thêm ${numImagesExceed > 0 ? 0 : numImagesExceed * -1} hình, ${numVideoExceed > 0 ? 0 : numVideoExceed * -1} video.';
        } else {
          errorString =
              'Quý khách chỉ có thể đăng tải tối đa thêm ${numImagesExceed > 0 ? 0 : numImagesExceed * -1} hình.';
        }
        emit(PropertyMediaStartTimerState());
      } else {
        errorString = '';
        emit(PropertyMediaCaptureImageSuccess());
      }
    }
  }

  FutureOr<void> _uploadFiles(
    PropertyMediaUploadFilesEvent event,
    Emitter<PropertyMediaState> emit,
  ) async {
    Util.showLoading();
    emit(PropertyMediaInitial());

    final listChangeCaption = listAssets.where((element) => element.isFileModel && element.isChangeCaption).toList();
    List<PropzyHomeUpdateCaptionRequest> listChangeRequests = [];
    for (PropzyHomeMediaAssetModel assetMedia in listChangeCaption) {
      final id = assetMedia.file?.id;
      final captionId = assetMedia.caption?.id;
      if (id != null && captionId != null) {
        final request = PropzyHomeUpdateCaptionRequest(id: id, captionId: captionId);
        listChangeRequests.add(request);
      }
    }
    await Future.wait(
      listChangeRequests.map((request) => updateCaptionFileUseCase.updateCaptionFile(request)),
    );

    final listNotUpload = listAssets
        .where((element) => !element.isUploadSuccess && element.assetEntity != null)
        .toList();

    final listFutureFiles = listNotUpload.map((e) => e.assetEntity!.originFile).toList();
    List<File?> listFiles = await Future.wait(listFutureFiles);

    List<PropzyHomeUploadFileRequest> listRequests = [];
    for (int i = 0; i < listNotUpload.length; i++) {
      final file = listFiles[i];
      final assetMedia = listNotUpload[i];
      if (file != null) {
        final request = PropzyHomeUploadFileRequest(
          file: file,
          captionId: assetMedia.caption?.id,
          id: assetMedia.caption?.id,
          offerId: offerId,
          typeSource: typeSource,
          typeFile: assetMedia.typeFile,
        );
        listRequests.add(request);
      }
    }

    final responses = await Future.wait(
      listRequests.map((request) => uploadFileUseCase.uploadFile(request)),
    );

    for (int i = 0; i < listNotUpload.length; i++) {
      final response = responses[i];
      if (response.result == true) {
        final mediaAsset = listNotUpload[i];
        listAssets.firstWhere((element) => element == mediaAsset).isUploadSuccess = true;
      }
    }
    Util.hideLoading();
    emit(PropertyMediaUploadFilesSuccess());
  }

  FutureOr<void> _deleteFile(
    PropertyMediaDeleteFileEvent event,
    Emitter<PropertyMediaState> emitter,
  ) async {
    Util.showLoading();
    emitter(PropertyMediaInitial());
    final fileId = event.assetModel.file?.id;
    if (fileId != null) {
      final response = await deleteFileUseCase.deleteFile(fileId);
      if (response.result == true) {
        listAssets.remove(event.assetModel);
        emitter(PropertyMediaDeleteFileSuccess());
      }
    } else if (event.assetModel.assetEntity != null) {
      selectedAssets.remove(event.assetModel.assetEntity);
      listAssets.remove(event.assetModel);
      emitter(PropertyMediaDeleteFileSuccess());
    }
    Util.hideLoading();
  }

  Future<bool> getGuideStatus() async {
    if (typeSource == Constants.MEDIA_SOURCE_TYPE_LEGAL) {
      return await prefHelper.getGuideLegalStatus() ?? false;
    } else {
      return await prefHelper.getGuideMediaStatus() ?? false;
    }
  }

  Future<void> setGuideStatus() async {
    if (typeSource == Constants.MEDIA_SOURCE_TYPE_LEGAL) {
      await prefHelper.setGuideLegalStatus(true);
    } else {
      await prefHelper.setGuideMediaStatus(true);
    }
  }

  List<HomeCaptionMediaModel> getListCaptionsForAsset(int typeSource, int typeFile) {
    if (typeSource == Constants.MEDIA_SOURCE_TYPE_LEGAL) {
      return listCaptions.where((element) => (element.type ?? 1) == 2).toList();
    } else if (typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
      if (typeFile == Constants.MEDIA_FILE_TYPE_IMAGE) {
        return listCaptions.where((element) => (element.type ?? 1) == 1).toList();
      } else if (typeFile == Constants.MEDIA_FILE_TYPE_VIDEO) {
        return listCaptions.where((element) => (element.type ?? 1) == 3).toList();
      }
    }
    return [];
  }

  FutureOr<void> _selectCaption(
    PropertyMediaSelectCaptionEvent event,
    Emitter<PropertyMediaState> emitter,
  ) {
    emitter(PropertyMediaInitial());
    final mediaAsset = event.mediaAsset;
    final caption = event.caption;
    final index = listAssets.indexOf(mediaAsset);
    if (index != -1) {
      listAssets[index].caption = caption;
      if (mediaAsset.isFileModel) {
        listAssets[index].isChangeCaption = true;
      }
    }
    emitter(PropertyMediaSelectCaptionSuccess());
  }
}
