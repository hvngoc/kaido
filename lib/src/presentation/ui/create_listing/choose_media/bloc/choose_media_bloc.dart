import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/request/listing_image_request.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/domain/usecase/upload_image_use_case.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_media/models/listing_media_asset_model.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

part 'choose_media_event.dart';

part 'choose_media_state.dart';

class ChooseMediaBloc extends Bloc<ChooseMediaEvent, ChooseMediaState> {
  final UploadImageUseCase _uploadImageUseCase = GetIt.instance.get<UploadImageUseCase>();
  final UpdateImageListingUseCase _updateUseCase = GetIt.instance.get<UpdateImageListingUseCase>();

  ChooseMediaBloc({required this.listingID}) : super(ChooseMediaInitial()) {
    on<ChooseMediaCaptureImageEvent>(_captureImage);
    on<ChooseMediaSelectFromAlbumEvent>(_selectFromAlbum);
    on<UploadImageEvent>(_uploadImage);
    on<ChooseMediaTimerEndEvent>(_timerEnd);
    on<ChooseMediaDeleteFileEvent>(_deleteFile);
    on<ChooseMediaSetDefaultEvent>(_setDefault);
    on<ChooseMediaLoadDataEvent>(_loadData);
  }

  final int listingID;

  // final int typeSource;

  List<AssetEntity> selectedAssets = [];
  List<ListingMediaAssetModel> listAssets = [];

  List<AssetEntity> selectedAssetsLegal = [];
  List<ListingMediaAssetModel> listAssetsLegal = [];

  String errorString = '';

  final String currentStep = "IMAGE_UPLOAD_STEP";
  final listImageFormats = ['image/jpeg', 'image/jpg', 'image/png', 'image/heic'];
  final int maxSizeImageInMB = 10;

  bool validateMinAssets() {
    return listAssets.length >= 4;
  }

  void _mapFromOfferDetail(List<MediaListing> listMediaListing) {
    listAssets.clear();
    selectedAssets.clear();
    listAssetsLegal.clear();
    selectedAssetsLegal.clear();

    var filteredFiles = listMediaListing
        .where((file) => (file.sourceType ?? 0) == Constants.MEDIA_SOURCE_TYPE_MEDIA)
        .toList();

    if (filteredFiles.length > 0) {
      final initialList = filteredFiles
          .map(
            (e) => ListingMediaAssetModel(
              mediaListing: e,
              typeSource: Constants.MEDIA_SOURCE_TYPE_MEDIA,
              isDefault: e.isDefault ?? false,
              isUploadSuccess: true,
            ),
          )
          .toList();
      listAssets = initialList;
    }

    var filteredFilesLegal = listMediaListing
        .where((file) => (file.sourceType ?? 0) == Constants.MEDIA_SOURCE_TYPE_LEGAL)
        .toList();
    if (filteredFilesLegal.length > 0) {
      final initialListLegal = filteredFilesLegal
          .map(
            (e) => ListingMediaAssetModel(
              mediaListing: e,
              typeSource: Constants.MEDIA_SOURCE_TYPE_LEGAL,
              isDefault: e.isDefault ?? false,
              isUploadSuccess: true,
            ),
          )
          .toList();
      listAssetsLegal = initialListLegal;
    }
  }

  FutureOr<void> _loadData(
    ChooseMediaLoadDataEvent event,
    Emitter<ChooseMediaState> emitter,
  ) async {
    emitter(ChooseMediaInitial());
    _mapFromOfferDetail(event.listMediaListing ?? []);
    emitter(ChooseMediaLoadDataSuccess());
  }

  FutureOr<void> _setDefault(
    ChooseMediaSetDefaultEvent event,
    Emitter<ChooseMediaState> emitter,
  ) async {
    emitter(ChooseMediaInitial());
    final isMedia = event.isMedia;
    if (isMedia) {
      listAssets.forEach((element) {
        if (element == event.assetModel) {
          element.isDefault = true;
        } else {
          element.isDefault = false;
        }
      });
    } else {
      listAssetsLegal.forEach((element) {
        if (element == event.assetModel) {
          element.isDefault = true;
        } else {
          element.isDefault = false;
        }
      });
    }
    emitter(ChooseMediaSetDefaultSuccess());
  }

  FutureOr<void> _deleteFile(
    ChooseMediaDeleteFileEvent event,
    Emitter<ChooseMediaState> emitter,
  ) async {
    Util.showLoading();
    emitter(ChooseMediaInitial());
    final isMedia = event.isMedia;
    if (event.assetModel.isMediaListing) {
      if (isMedia) {
        listAssets.remove(event.assetModel);
      } else {
        listAssetsLegal.remove(event.assetModel);
      }
      emitter(ChooseMediaDeleteFileSuccess());
    } else if (event.assetModel.isAssetEntity) {
      if (isMedia) {
        selectedAssets.remove(event.assetModel.assetEntity);
        listAssets.remove(event.assetModel);
      } else {
        selectedAssetsLegal.remove(event.assetModel.assetEntity);
        listAssetsLegal.remove(event.assetModel);
      }
      emitter(ChooseMediaDeleteFileSuccess());
    }
    Util.hideLoading();
  }

  FutureOr<void> _timerEnd(
    ChooseMediaTimerEndEvent event,
    Emitter<ChooseMediaState> emitter,
  ) {
    emitter(ChooseMediaInitial());
    errorString = '';
    emitter(ChooseMediaCaptureImageSuccess());
  }

  Future<File?> compressFile(File file, {int quality = 95}) async {
    final dir = await path_provider.getTemporaryDirectory();
    // final targetPath = dir.absolute.path + "/temp.jpg";
    final targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    int currentQuality = quality;
    File? targetFile = file;
    int sizeFile = file.lengthSync();
    print(sizeFile);
    bool isCompress = false;
    while (currentQuality > 0 && targetFile != null && sizeFile > (maxSizeImageInMB * 1024 * 1024)) {
      targetFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: currentQuality,
      );
      sizeFile = targetFile != null ? targetFile.lengthSync() : 0;
      currentQuality -= 10;

      print(sizeFile);
      isCompress = true;
    }
    if (!isCompress) {
      return null;
    }
    return targetFile;
  }

  FutureOr<void> _uploadImage(
    UploadImageEvent event,
    Emitter<ChooseMediaState> emitter,
  ) async {
    Util.showLoading();

    //Upload hình nhà
    final listNotUpload =
        listAssets.where((element) => !element.isUploadSuccess && element.isAssetEntity).toList();

    // final listFutureFiles = listNotUpload.map((e) => e.assetEntity!.originFile).toList();
    final listFutureFiles = listNotUpload.map((e) async {
      final assetEntity = e.assetEntity!;
      final originFile = await assetEntity.originFile;
      if (originFile != null) {
        if (originFile.lengthSync() > (maxSizeImageInMB * 1024 * 1024)) {
          final newFile = await compressFile(originFile);
          return newFile;
        }
        return originFile;
      }
      return null;
    }).toList();
    List<File?> listFiles = await Future.wait(listFutureFiles);

    final listResponses = await Future.wait(
      listFiles.map((file) {
        if (file != null) {
          return _uploadImageUseCase.uploadImage(file);
        }
        return Future(() => null);
      }),
    );

    //Call api update after upload images
    List<ListingMediaRequest> listJustUploaded = [];
    int totalUploadFail = 0;
    for (int i = 0; i < listResponses.length; i++) {
      final response = listResponses[i];
      if (response != null && response.isSuccess()) {
        final fileName = response.data?.file_name ?? '';
        if (fileName.isNotEmpty) {
          final isDefault = listNotUpload[i].isDefault;
          final request = ListingMediaRequest(
            fileName: fileName,
            isDefault: isDefault,
            sourceType: Constants.MEDIA_SOURCE_TYPE_MEDIA,
          );
          listJustUploaded.add(request);
        }
      } else {
        totalUploadFail += 1;
      }
    }

    if (totalUploadFail > 0) {
      errorString = 'Đăng tải thất bại ${totalUploadFail} hình nhà.';
      emitter(ChooseMediaStartTimerState());
      return;
    }

    //Upload hình giấy tờ pháp lý
    final listNotUploadLegal = listAssetsLegal
        .where((element) => !element.isUploadSuccess && element.isAssetEntity)
        .toList();

    final listFutureFilesLegal = listNotUploadLegal.map((e) => e.assetEntity!.originFile).toList();
    List<File?> listFilesLegal = await Future.wait(listFutureFilesLegal);

    final listResponsesLegal = await Future.wait(
      listFilesLegal.map((file) {
        if (file != null) {
          return _uploadImageUseCase.uploadImage(file);
        }
        return Future(() => null);
      }),
    );

    //Call api update after upload images
    List<ListingMediaRequest> listJustUploadedLegal = [];
    int totalUploadFailLegal = 0;
    for (int i = 0; i < listResponsesLegal.length; i++) {
      final response = listResponsesLegal[i];
      if (response != null && response.isSuccess()) {
        final fileName = response.data?.file_name ?? '';
        if (fileName.isNotEmpty) {
          final isDefault = listNotUploadLegal[i].isDefault;
          final request = ListingMediaRequest(
            fileName: fileName,
            isDefault: isDefault,
            sourceType: Constants.MEDIA_SOURCE_TYPE_LEGAL,
          );
          listJustUploadedLegal.add(request);
        }
      } else {
        totalUploadFailLegal += 1;
      }
    }

    if (totalUploadFailLegal > 0) {
      errorString = 'Đăng tải thất bại ${totalUploadFailLegal} hình giấy tờ pháp lý.';
      emitter(ChooseMediaStartTimerState());
      return;
    }

    List<ListingMediaRequest> listUpdateRequest = listAssets
        .where((element) => element.isUploadSuccess)
        .map((e) => ListingMediaRequest(
            fileName: e.mediaListing?.fileName,
            isDefault: e.isDefault,
            sourceType: e.mediaListing?.sourceType))
        .toList();
    listUpdateRequest.addAll(listJustUploaded);

    List<ListingMediaRequest> listUpdateRequestLegal = listAssetsLegal
        .where((element) => element.isUploadSuccess)
        .map((e) => ListingMediaRequest(
            fileName: e.mediaListing?.fileName,
            isDefault: e.isDefault,
            sourceType: e.mediaListing?.sourceType))
        .toList();
    listUpdateRequest.addAll(listUpdateRequestLegal);
    listUpdateRequest.addAll(listJustUploadedLegal);

    final updateResponse = await _updateUseCase.update(listingID, currentStep, listUpdateRequest);
    updateResponse.fold((l) {}, (r) {
      emitter(ChooseMediaUploadFilesSuccess());
    });
    Util.hideLoading();
  }

  FutureOr<void> _captureImage(
    ChooseMediaCaptureImageEvent event,
    Emitter<ChooseMediaState> emitter,
  ) async {
    emitter(ChooseMediaInitial());
    final isMedia = event.isMedia;
    final entity = event.assetEntity;

    var isExceedSize = false;
    var isWrongFormat = false;

    // final assetBytes = await entity.originBytes;
    final mimeType = (await entity.mimeTypeAsync ?? 'null').toLowerCase();
    final sizeMB = 0;//(assetBytes?.length ?? 0) / 1024 / 1024;
    if (entity.type == AssetType.image) {
      if (sizeMB > maxSizeImageInMB) {
        isExceedSize = true;
      } else if (!listImageFormats.contains(mimeType)) {
        isWrongFormat = true;
      }
    }

    if (isExceedSize) {
      errorString = 'Quý khách chỉ được đăng tải tối đa ${maxSizeImageInMB}MB/hình.';
      emitter(ChooseMediaStartTimerState());
      return;
    }

    if (isWrongFormat) {
      errorString = 'Quý khách chỉ được đăng tải định dạng JPG, JPEG, PNG, HEIC.';
      emitter(ChooseMediaStartTimerState());
      return;
    }

    final maxLimitImages =
        isMedia ? Constants.MAX_NUM_IMAGES_MEDIA : Constants.MAX_NUM_IMAGES_LEGAL;
    final listLength = isMedia ? listAssets.length : listAssetsLegal.length;

    if (listLength < maxLimitImages) {
      errorString = '';
      if (isMedia) {
        listAssets.add(
          ListingMediaAssetModel(
            assetEntity: entity,
            typeSource: Constants.MEDIA_SOURCE_TYPE_MEDIA,
          ),
        );
        selectedAssets.add(entity);
      } else {
        listAssetsLegal.add(
          ListingMediaAssetModel(
            assetEntity: entity,
            typeSource: Constants.MEDIA_SOURCE_TYPE_LEGAL,
          ),
        );
        selectedAssetsLegal.add(entity);
      }
      emitter(ChooseMediaCaptureImageSuccess());
    } else {
      errorString = 'Quý khách chỉ có thể đăng tải tối đa thêm 0 hình.';
      emitter(ChooseMediaStartTimerState());
    }
  }

  FutureOr<void> _selectFromAlbum(
    ChooseMediaSelectFromAlbumEvent event,
    Emitter<ChooseMediaState> emitter,
  ) async {
    final isMedia = event.isMedia;
    final results1 = event.pickedAssets;
    List<AssetEntity> results = [];
    if (results1 != null) {
      emitter(ChooseMediaInitial());
      var isExceedSize = false;
      var isWrongFormat = false;
      for (AssetEntity assetEntity in results1) {
        // final assetBytes = await assetEntity.originBytes;
        var mimeType = (await assetEntity.mimeTypeAsync ?? 'null').toLowerCase();
        if (Platform.isIOS) {
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          var iosInfo = await deviceInfo.iosInfo;
          if (!iosInfo.isPhysicalDevice) {
            mimeType = 'image/jpeg'; //Fix for ios simulator return mimeType null
          }
        }

        final sizeMB = 0;//(assetBytes?.length ?? 0) / 1024 / 1024;
        if (assetEntity.type == AssetType.image) {
          if (sizeMB > maxSizeImageInMB) {
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

      final maxLimitImages =
          isMedia ? Constants.MAX_NUM_IMAGES_MEDIA : Constants.MAX_NUM_IMAGES_LEGAL;

      final numImagesExceed =
          (isMedia ? listAssets.length : listAssetsLegal.length) + results.length - maxLimitImages;
      if (numImagesExceed > 0) {
        for (int i = 0; i < numImagesExceed; i++) {
          results.removeLast();
        }
      }

      if (isMedia) {
        var tmpList = listAssets.where((element) => element.isMediaListing).toList();

        for (AssetEntity asset in results) {
          final foundedAsset = listAssets.firstWhere((element) => element.assetEntity == asset,
              orElse: () => ListingMediaAssetModel());
          tmpList.add(ListingMediaAssetModel(
            assetEntity: asset,
            typeSource: Constants.MEDIA_SOURCE_TYPE_MEDIA,
            isDefault: foundedAsset.isDefault,
            isUploadSuccess: false,
          ));
        }

        selectedAssets = results;
        listAssets = tmpList;
      } else {
        var tmpList = listAssetsLegal.where((element) => element.isMediaListing).toList();

        for (AssetEntity asset in results) {
          final foundedAsset = listAssetsLegal.firstWhere((element) => element.assetEntity == asset,
              orElse: () => ListingMediaAssetModel());
          tmpList.add(ListingMediaAssetModel(
            assetEntity: asset,
            typeSource: Constants.MEDIA_SOURCE_TYPE_LEGAL,
            isDefault: foundedAsset.isDefault,
            isUploadSuccess: false,
          ));
        }

        selectedAssetsLegal = results;
        listAssetsLegal = tmpList;
      }

      if (isExceedSize) {
        errorString = 'Quý khách chỉ được đăng tải tối đa ${maxSizeImageInMB}MB/hình.';
        emitter(ChooseMediaStartTimerState());
        return;
      }

      if (isWrongFormat) {
        errorString = 'Quý khách chỉ được đăng tải định dạng JPG, JPEG, PNG, HEIC.';
        emitter(ChooseMediaStartTimerState());
        return;
      }

      if (numImagesExceed > 0) {
        errorString =
            'Quý khách chỉ có thể đăng tải tối đa thêm ${numImagesExceed > 0 ? 0 : numImagesExceed * -1} hình.';
        emitter(ChooseMediaStartTimerState());
      } else {
        errorString = '';
        emitter(ChooseMediaCaptureImageSuccess());
      }
    }
  }
}
