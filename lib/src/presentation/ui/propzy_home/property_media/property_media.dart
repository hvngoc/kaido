import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/bloc/property_media_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/models/propzy_home_media_model.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/widgets/add_image_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/widgets/asset_preview_item.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/widgets/guide_line_media_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/alert_dialog.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PropertyMedia extends StatefulWidget {
  const PropertyMedia({
    Key? key,
    required this.offerId,
    this.typeSource = 1,
  }) : super(key: key);

  final int offerId;
  final int typeSource;

  @override
  State<PropertyMedia> createState() => _PropertyMediaState();
}

class _PropertyMediaState extends State<PropertyMedia> {
  late PropertyMediaBloc _bloc;
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();
  Timer? _timer;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _bloc = PropertyMediaBloc(
        offerId: widget.offerId, typeSource: widget.typeSource);
    _bloc.add(PropertyMediaGetListCaptionEvent());
    _propzyHomeBloc.add(GetOfferDetailEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
        BlocProvider(create: (_) => _propzyHomeBloc),
      ],
      child: BlocConsumer<PropzyHomeBloc, PropzyHomeState>(
        bloc: _propzyHomeBloc,
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            if (state is UpdateOfferSuccessState) {
              if (widget.typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
                NavigationController.navigateToPropertyMedia(
                  context,
                  widget.offerId,
                  typeSource: Constants.MEDIA_SOURCE_TYPE_LEGAL,
                );
              } else if (widget.typeSource ==
                  Constants.MEDIA_SOURCE_TYPE_LEGAL) {
                NavigationController.navigateToIBuyConfirmOwner(context);
              }
            } else if (state is GetOfferDetailSuccess) {
              _bloc.add(PropertyMediaGetOfferEvent(_propzyHomeBloc.draftOffer));
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<PropertyMediaBloc, PropertyMediaState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is PropertyMediaUploadFilesSuccess) {
                var reachedCode = '';
                if (widget.typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA) {
                  reachedCode = PropzyHomeScreenDirect.UPLOAD_IMG.pageCode;
                } else if (widget.typeSource ==
                    Constants.MEDIA_SOURCE_TYPE_LEGAL) {
                  reachedCode = PropzyHomeScreenDirect.CERTIFICATE_IMG.pageCode;
                }
                final reachedPage =
                    _propzyHomeBloc.getReachedPageId(reachedCode);
                final event = UpdateOfferEvent(
                  reachedPageId: reachedPage,
                );
                _propzyHomeBloc.add(event);
              }
              if (state is PropertyMediaStartTimerState) {
                if (_timer != null) {
                  _timer?.cancel();
                }
                _counter = Constants.DURATION_SECONDS_DISPLAY_ERROR_MEDIA;
                _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                  if (_counter > 0) {
                    _counter -= 1;
                  } else {
                    _timer?.cancel();
                    _bloc.add(PropertyMediaTimerEndEvent());
                  }
                });
              }
              if (state is PropertyMediaCaptureImageSuccess) {
                if (_timer != null) {
                  _timer?.cancel();
                  _timer = null;
                }
              }
            },
            builder: (context, state) {
              return Scaffold(
                body: SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _renderHeader(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child:
                              PropzyHomeProgressPage(offerId: widget.offerId),
                        ),
                        _renderTitleInfoText(),
                        _renderWarningMessage(_bloc.errorString),
                        Expanded(
                          child: ListView(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AddImageButton(
                                      iconName:
                                          'assets/images/ic_iBuyer_capture.svg',
                                      title: 'Chụp ảnh',
                                      onTapAction: (context) async {
                                        _checkPermissionCamera();
                                      },
                                    ),
                                    SizedBox(width: 16),
                                    AddImageButton(
                                      iconName:
                                          'assets/images/ic_iBuyer_album.svg',
                                      title: 'Upload ảnh',
                                      onTapAction: (context) async {
                                        _checkPermissionAlbum();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<PropertyMediaBloc,
                                  PropertyMediaState>(
                                builder: (context, state) {
                                  return _renderListAssets(_bloc.listAssets);
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Column(
                            children: [
                              OrangeButton(
                                title: 'Tiếp tục',
                                onPressed: () {
                                  _uploadImages();
                                },
                              ),
                              _renderSkipButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _uploadImages() async {
    if (_bloc.validateMinAssets()) {
      _bloc.add(PropertyMediaUploadFilesEvent());
    } else {
      AppAlert.showWarningAlert(
        context,
        'Vui lòng upload tối thiểu 4 hình ảnh',
      );
    }
  }

  void _checkPermissionCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final guideStatus = await _bloc.getGuideStatus();
      if (guideStatus == false) {
        _showGuideLineSheet(context, true);
      } else {
        _captureImage();
      }
    } else {
      Util.showOpenSettings(context, Constants.cameraPermissionMessage);
    }
  }

  void _checkPermissionAlbum() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      final guideStatus = await _bloc.getGuideStatus();
      if (guideStatus == false) {
        _showGuideLineSheet(context, false);
      } else {
        _selectImageFromAlbum();
      }
    } else {
      Util.showOpenSettings(context, Constants.albumPermissionMessage);
    }
  }

  void _captureImage() async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
        textDelegate: EnglishCameraPickerTextDelegate(),
        enableRecording: widget.typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA
            ? true
            : false,
        enableAudio: false,
        resolutionPreset: ResolutionPreset.high,
        maximumRecordingDuration: Duration(seconds: 120),
      ),
    );

    if (entity != null && this.mounted) {
      _bloc.add(PropertyMediaCaptureImageEvent(entity));
    }
  }

  void _selectImageFromAlbum() async {
    final selectedAssets = _bloc.selectedAssets;
    final List<AssetEntity>? results = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        selectedAssets: selectedAssets,
        specialPickerType: SpecialPickerType.noPreview,
        gridCount: 3,
        pageSize: 60,
        maxAssets:
            widget.typeSource == Constants.MEDIA_SOURCE_TYPE_LEGAL ? 6 : 25,
        themeColor: AppColor.orangeDark,
        requestType: widget.typeSource == Constants.MEDIA_SOURCE_TYPE_LEGAL
            ? RequestType.image
            : RequestType.common,
      ),
    );
    _bloc.add(PropertyMediaSelectFromAlbumEvent(results));
  }

  Widget makeDismissable({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(onTap: () {}, child: child),
      );

  void _showGuideLineSheet(BuildContext context, bool isCapture) async {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return makeDismissable(
          child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, controller) => GuideLineMediaView(
              isLegal: widget.typeSource == Constants.MEDIA_SOURCE_TYPE_LEGAL,
              onPressed: () async {
                await _bloc.setGuideStatus();
                if (isCapture) {
                  Future.delayed(Duration(seconds: 1), _captureImage);
                } else {
                  Future.delayed(Duration(seconds: 1), _selectImageFromAlbum);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _renderListAssets(List<PropzyHomeMediaAssetModel> listAssets) {
    if (listAssets.length == 0) {
      return Container(
        padding: EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        child: Lottie.asset(
          'assets/json/empty_searching.json',
          width: 140,
          height: 140,
          repeat: true,
          frameRate: FrameRate.max,
        ),
      );
    }
    return GridView.count(
      // primary: false,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: listAssets
          .map(
            (mediaAsset) => AssetPreviewItem(
              mediaAsset: mediaAsset,
              onTapCallback: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        _showPickerCaption(context, mediaAsset));
              },
            ),
          )
          .toList(),
    );
  }

  Widget _renderTitleInfoText() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 12),
      child: Column(
        children: [
          Text(
            widget.typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA
                ? 'Chia sẻ hình ảnh căn nhà cùng Propzy'
                : 'Ảnh giấy tờ pháp lý, chủ quyền căn nhà',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            widget.typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA
                ? 'Quá tuyệt vời khi chỉ còn 1 bước nữa thôi, bạn sẽ nhận giá đề nghị sơ bộ từ Propzy'
                : 'Các thông tin bạn cung cấp sẽ được bảo mật tuyệt đối bởi Propzy',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColor.propzyHomeDes,
            ),
          ),
          SizedBox(height: 20),
          Text(
            widget.typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA
                ? 'Đăng tải từ 4 đến 20 hình hoặc để thu hút hơn bạn có thể thêm video (dưới 3 phút)'
                : 'Đăng tải từ 4 đến 6 hình',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.propzyHomeDes,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderWarningMessage(String errorMessage) {
    if (errorMessage.isEmpty) {
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: HexColor('F8D7DA'),
      child: Text(
        errorMessage,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _renderSkipButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Container(
        height: 50,
        color: Colors.transparent,
        child: Center(
          child: Text(
            'Bổ sung sau',
            style: TextStyle(
              color: AppColor.systemBlue,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderHeader() {
    return Container(
      color: Colors.white,
      child: PropzyHomeHeaderView(
          isLoadOfferDetail:
              widget.typeSource == Constants.MEDIA_SOURCE_TYPE_LEGAL),
    );
  }

  Widget _showPickerCaption(
      BuildContext context, PropzyHomeMediaAssetModel mediaAsset) {
    return _showPickerDialog(
      context,
      _bloc.getListCaptionsForAsset(mediaAsset.typeSource, mediaAsset.typeFile),
      mediaAsset,
      (caption) {
        _bloc.add(PropertyMediaSelectCaptionEvent(mediaAsset, caption));
        Navigator.of(context).pop();
      },
    );
  }

  Widget _showPickerDialog(
    BuildContext context,
    List<HomeCaptionMediaModel>? list,
    PropzyHomeMediaAssetModel? current,
    Function(HomeCaptionMediaModel) callback,
  ) {
    if (list == null) {
      return Container();
    }
    List<Widget> view = list
        .map((e) => SortItemChildView(
            text: e.name ?? '',
            isChecked: e.id == current?.caption?.id,
            onClick: () {
              callback(e);
            }))
        .toList();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                'Chọn ghi chú',
                style: TextStyle(
                  color: AppColor.blackDefault,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => view[index],
                itemCount: view.length,
                padding: EdgeInsets.only(left: 20, right: 20),
                separatorBuilder: (c, i) {
                  return Divider(
                    color: AppColor.dividerGray,
                    height: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
