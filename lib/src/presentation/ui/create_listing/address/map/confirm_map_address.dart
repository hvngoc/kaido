import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/map/bloc/confirm_map_address_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/map/bloc/confirm_map_address_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/map/bloc/confirm_map_address_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/location_util.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class ConfirmMapAddressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfirmMapAddressScreenState();
}

class _ConfirmMapAddressScreenState extends State<ConfirmMapAddressScreen> {
  final CreateListingBloc _createListingBloc = GetIt.instance.get<CreateListingBloc>();
  final ConfirmMapAddressBloc _confirmMapAddressBloc = GetIt.instance.get<ConfirmMapAddressBloc>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late Marker marker;
  GoogleMapController? _mapController;
  final String currentStep = "MAP_STEP";

  late double? currentLat;
  late double? currentLng;

  @override
  void initState() {
    super.initState();

    currentLat = _createListingBloc.createListingRequest?.latitude;
    currentLng = _createListingBloc.createListingRequest?.longitude;

    marker = Marker(
      markerId: MarkerId("currentPosition"),
      position: LatLng(
        currentLat ?? PROPZY_LATITUDE,
        currentLng ?? PROPZY_LONGITUDE,
      ),
    );

    setState(() {
      markers[MarkerId("currentPosition")] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _confirmMapAddressBloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: BlocConsumer<CreateListingBloc, BaseCreateListingState>(
        bloc: _createListingBloc,
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            if (state is GetDraftListingDetailSuccessState) {
            } else if (state is ListingLoadingState) {
              Util.showLoading();
            } else if (state is ErrorMessageState) {
              Util.hideLoading();
              Util.showMyDialog(
                context: context,
                message: state.errorMessage ?? MessageUtil.errorMessageDefault,
              );
            } else if (state is CreateListingSuccessState) {
              Util.hideLoading();
              navigateToPropertyType();
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<ConfirmMapAddressBloc, ConfirmMapAddressState>(
            bloc: _confirmMapAddressBloc,
            listener: (context, state) {
              if (state is LoadingState) {
                Util.showLoading();
              } else if (state is ErrorState) {
                Util.hideLoading();
                Util.showMyDialog(
                  context: context,
                  message: state.message ?? MessageUtil.errorMessageDefault,
                );
              } else if (state is SuccessUpdateMapState) {
                Util.hideLoading();
                navigateToPropertyType();
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
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _renderProgressBar(),
                              SizedBox(height: 16),
                              _renderTitle(),
                              SizedBox(height: 8),
                              _renderSubTitle(),
                              SizedBox(height: 24),
                              _renderContent(),
                              SizedBox(height: 8),
                              _renderFooter(),
                            ],
                          ),
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

  Widget _renderProgressBar() {
    return CreateListingProgressBarView(
      currentStep: 1,
      currentScreenInStep: 2,
      totalScreensInStep: 2,
      padding: 14,
      parentPadding: 16,
    );
  }

  Widget _renderTitle() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          "Vị trí bất động sản trên bản đồ",
          style: TextStyle(
            color: AppColor.secondaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _renderSubTitle() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          "Vị trí trên bản đồ được ghim đúng giúp khách hàng tìm đến bạn dễ dàng hơn",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.secondaryText,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _renderContent() {
    return Expanded(
      child: Stack(
        children: [
          _renderGoogleMap(),
          _renderLabelFullAddress(),
          _renderMarker(),
          _renderButtonCurrentPosition(),
        ],
      ),
    );
  }

  Widget _renderFooter() {
    return PropzyHomeContinueButton(
      isEnable: true,
      fontWeight: FontWeight.w700,
      onClick: () {
        if (_createListingBloc.createListingRequest?.id != null) {
          UpdateMapListingRequest request = UpdateMapListingRequest(
            id: _createListingBloc.createListingRequest!.id!,
            latitude: currentLat,
            longitude: currentLng,
          );
          _confirmMapAddressBloc.add(UpdateMapListingEvent(request));
        } else {
          _createListingBloc.createListingRequest?.latitude = currentLat;
          _createListingBloc.createListingRequest?.longitude = currentLng;
          _createListingBloc.createListingRequest?.currentStep = currentStep;

          _createListingBloc.add(CreateListingEvent());
        }
      },
    );
  }

  Widget _renderGoogleMap() {
    return SizedBox.expand(
      child: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        onCameraMove: (position) {
          currentLat = position.target.latitude;
          currentLng = position.target.longitude;
        },
        // onTap: (latLng) {
        //   print("lat: ${latLng.latitude} - lng: ${latLng.longitude}");
        // },
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        // markers: Set<Marker>.of(markers.values),
        initialCameraPosition: CameraPosition(
          target: LatLng(
            currentLat ?? PROPZY_LATITUDE,
            currentLng ?? PROPZY_LONGITUDE,
          ),
          zoom: 16,
        ),
        gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
      ),
    );
  }

  Widget _renderLabelFullAddress() {
    return Container(
      height: 40,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/vector_ic_geo.svg",
            width: 12,
            height: 12,
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              _createListingBloc.createListingRequest?.address ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: AppColor.blackDefault,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 6),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: HexColor("0072EF")),
                  ),
                ),
                child: Text(
                  "Sửa",
                  style: TextStyle(
                    color: HexColor("0072EF"),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderMarker() {
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 220,
            height: 50,
            decoration: BoxDecoration(
              color: AppColor.orangeDark,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Địa chỉ của bạn ở đây",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Vui lòng kiểm tra vị trí trên bản đồ",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/ic_pin_location_orange.png",
            width: 30,
            height: 40,
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _renderButtonCurrentPosition() {
    return Container(
      margin: EdgeInsets.only(right: 10, bottom: 14),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            onPressed: () async {
              await onClickUseMyLocation();
            },
            child: SvgPicture.asset(
              "assets/images/ic_get_current_location.svg",
              width: 20,
              height: 20,
            ),
            backgroundColor: Colors.white,
            // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ),
    );
  }

  Future<void> onClickUseMyLocation() async {
    if (await Permission.location.isGranted) {
      getCurrentLocation();
    } else {
      PermissionStatus statuses = await Permission.location.request();
      if (statuses.isGranted) {
        getCurrentLocation();
      } else {
        Util.showMyDialog(
          context: context,
          title: "Thông báo",
          message: "Để sử dụng tính năng này bạn cần cấp quyền cho hệ thống.",
          textActionCancel: "Hủy",
          actionCancel: () {},
          textActionOk: "Ok",
          actionOk: () {
            openAppSettings();
          },
        );
      }
    }
  }

  void getCurrentLocation() {
    LocationUtil.getLastKnownPosition(onSuccess: (position) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(
        position?.latitude ?? PROPZY_POSITION.latitude,
        position?.longitude ?? PROPZY_POSITION.longitude,
      )));
    }, onError: (ex) {
      Log.e(ex);
    });
  }

  void navigateToPropertyType() {
    NavigationController.navigateCreatePropertyType(
      context,
      _createListingBloc.createListingRequest?.id ?? 0,
    );
  }
}
