import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_media/bloc/choose_media_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_media/models/listing_media_asset_model.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_media/widget/listing_asset_preview_item.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/title_description_info_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/widgets/add_image_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/widgets/guide_line_media_view.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/alert_dialog.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ChooseMediaWidget extends StatefulWidget {
  ChooseMediaWidget({
    Key? key,
    required this.listingID,
  }) : super(key: key);

  final int listingID;

  @override
  State<ChooseMediaWidget> createState() => _ChooseMediaWidgetState();
}

class _ChooseMediaWidgetState extends State<ChooseMediaWidget> {
  late final ChooseMediaBloc _bloc;
  final CreateListingBloc _createListingBloc = GetIt.instance.get<CreateListingBloc>();

  Timer? _timer;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _bloc = ChooseMediaBloc(listingID: widget.listingID);
    _createListingBloc.add(GetDraftListingDetailEvent(widget.listingID));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: BlocConsumer<CreateListingBloc, BaseCreateListingState>(
        bloc: _createListingBloc,
        listener: (context, state) {
          if (state is GetDraftListingDetailSuccessState) {
            _bloc.add(ChooseMediaLoadDataEvent(_createListingBloc.draftListing?.media));
          } else if (state is ListingLoadingState) {
            Util.showLoading();
          } else if (state is ErrorMessageState) {
            Util.hideLoading();
          }
        },
        builder: (context, state) {
          return BlocConsumer<ChooseMediaBloc, ChooseMediaState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is ChooseMediaUploadFilesSuccess) {
                NavigationController.navigateToOwnerInfoCreateListing(context);
              } else if (state is ChooseMediaLoadDataSuccess) {
                Util.hideLoading();
              } else if (state is ChooseMediaStartTimerState) {
                if (_timer != null) {
                  _timer?.cancel();
                }
                _counter = 10;
                _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                  if (_counter > 0) {
                    _counter -= 1;
                  } else {
                    _timer?.cancel();
                    _bloc.add(ChooseMediaTimerEndEvent());
                  }
                });
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: PropzyAppBar(
                  title: 'Đăng tin bất động sản',
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      CreateListingProgressBarView(
                        currentStep: 3,
                        currentScreenInStep: 1,
                        totalScreensInStep: 1,
                      ),
                      TitleDescriptionInfoView(
                        title: 'Hình ảnh bất động sản của bạn',
                        description:
                            'Những tin đăng có hình ảnh sẽ được xem nhiều hơn gấp 10 lần so với tin đăng không ảnh',
                      ),
                      _renderWarningMessage(_bloc.errorString),
                      Expanded(
                        child: ListView(
                          children: [
                            _renderNotePart(true),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AddImageButton(
                                    iconName: 'assets/images/ic_iBuyer_capture.svg',
                                    title: 'Chụp ảnh',
                                    onTapAction: (context) async {
                                      _checkPermissionCamera(true);
                                    },
                                  ),
                                  SizedBox(width: 16),
                                  AddImageButton(
                                    iconName: 'assets/images/ic_iBuyer_album.svg',
                                    title: 'Upload ảnh',
                                    onTapAction: (context) async {
                                      _checkPermissionAlbum(true);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            _renderListAssets(_bloc.listAssets, true),
                            _renderNotePart(false),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AddImageButton(
                                    iconName: 'assets/images/ic_iBuyer_capture.svg',
                                    title: 'Chụp ảnh',
                                    onTapAction: (context) async {
                                      _checkPermissionCamera(false);
                                    },
                                  ),
                                  SizedBox(width: 16),
                                  AddImageButton(
                                    iconName: 'assets/images/ic_iBuyer_album.svg',
                                    title: 'Upload ảnh',
                                    onTapAction: (context) async {
                                      _checkPermissionAlbum(false);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            _renderListAssets(_bloc.listAssetsLegal, false),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: OrangeButton(
                          title: 'Tiếp tục',
                          isEnabled: _bloc.validateMinAssets(),
                          onPressed: () {
                            _bloc.add(UploadImageEvent());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _renderNotePart(bool isMediaScreen) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: isMediaScreen ? 'Hình ảnh bất động sản' : 'Hình ảnh giấy tờ pháp lý',
                  children: [
                    TextSpan(
                      text: isMediaScreen ? ' *' : '',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(text: ' ('),
                    TextSpan(
                      text: 'Xem hướng dẫn',
                      style: TextStyle(
                        color: AppColor.blueLink,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.normal,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _showGuideLineSheet(context, isMediaScreen);
                        },
                    ),
                    TextSpan(text: ')'),
                  ],
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                isMediaScreen ? 'Đăng tải từ 4 đến 20 hình' : 'Đăng tải tối đa 6 hình',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderListAssets(List<ListingMediaAssetModel> listAssets, bool isMedia) {
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
      childAspectRatio: 1.3,
      physics: NeverScrollableScrollPhysics(),
      children: listAssets
          .map(
            (mediaAsset) => ListingAssetPreviewItem(
              mediaAsset: mediaAsset,
              isMedia: isMedia,
              onTapCallback: () {
                _bloc.add(ChooseMediaSetDefaultEvent(mediaAsset, isMedia));
              },
            ),
          )
          .toList(),
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

  void _showGuideLineSheet(BuildContext context, bool isMediaScreen) async {
    Util.showCustomBottomSheet(
      context,
      (context) => GuideLineMediaView(
        isLegal: !isMediaScreen,
        onPressed: () {},
      ),
    );
  }

  void _checkPermissionCamera(bool isMedia) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _captureImage(isMedia);
    } else {
      Util.showOpenSettings(context, Constants.cameraPermissionMessage);
    }
  }

  void _checkPermissionAlbum(bool isMedia) async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      _selectImageFromAlbum(isMedia);
    } else {
      Util.showOpenSettings(context, Constants.albumPermissionMessage);
    }
  }

  void _captureImage(bool isMedia) async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
        textDelegate: EnglishCameraPickerTextDelegate(),
        enableRecording: false,
        enableAudio: false,
        resolutionPreset: ResolutionPreset.high,
        maximumRecordingDuration: Duration(seconds: 120),
      ),
    );

    if (entity != null && this.mounted) {
      _bloc.add(ChooseMediaCaptureImageEvent(entity, isMedia));
    }
  }

  void _selectImageFromAlbum(bool isMedia) async {
    final selectedAssets = isMedia ? _bloc.selectedAssets : _bloc.selectedAssetsLegal;
    final List<AssetEntity>? results = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        selectedAssets: selectedAssets,
        specialPickerType: SpecialPickerType.noPreview,
        gridCount: 3,
        pageSize: 60,
        maxAssets: isMedia ? 20 : 6,
        themeColor: AppColor.orangeDark,
        requestType: RequestType.image,
      ),
    );
    _bloc.add(ChooseMediaSelectFromAlbumEvent(results, isMedia));
  }
}
