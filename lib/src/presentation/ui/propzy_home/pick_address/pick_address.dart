import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:propzy_home/src/data/local/db/app_database.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/domain/model/propzy_map_model.dart';
import 'package:propzy_home/src/domain/request/propzy_home_create_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_map_request.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_city/choose_city_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_district/choose_district_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_street/choose_street_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_ward/choose_ward_widget.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/propzy_home_map_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/suggestion_house_number_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/location_util.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:rubber/rubber.dart';
import 'package:rxdart/rxdart.dart';

class PickAddressScreen extends StatefulWidget {

  PickAddressScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PickAddressScreenState();
}

class _PickAddressScreenState extends State<PickAddressScreen> with SingleTickerProviderStateMixin {
  PickAddressBloc _bloc = GetIt.instance.get<PickAddressBloc>();
  PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();
  final PrefHelper prefHelper = GetIt.instance.get<PrefHelper>();
  final AppDatabase appDatabase = GetIt.instance.get<AppDatabase>();

  late PropzyHomePropertyType? propertyType;

  String SCREEN_PAGE_CODE = PropzyHomeScreenDirect.MAP_LOCATION_CORRECT.pageCode;

  HomeOfferModel? draftOffer = null;
  UserInfo? userInfo = null;
  String? sessionMap = null;
  late InAppWebViewController _inAppWebViewController;

  late RubberAnimationController _rubberAnimationController;

  ScrollController _scrollController = ScrollController();
  ScrollController _scrollControllerListSearchAddress = ScrollController();
  bool isLoadingMoreListSearch = false;
  bool isLoadAllDataSearch = false;

  PropzyHomeMapView lastWidgetForMapView = PropzyHomeMapView();
  Subject<HashMap<String, String>> streamLocationChange = PublishSubject();
  Subject<String> streamTextSearchChange = PublishSubject();
  Subject<String> streamTextHouseNumberChange = PublishSubject();

  String currentLat = "";
  String currentLng = "";
  bool isLoadMapDone = false;
  int currentPageSearch = 1;
  bool isShowLabelError = true;
  bool isShowBottomSheetInput = false;
  bool isClickItemSuggestion = false;
  bool isInputHouseNumberByKeyboard = false;

  // input form
  int? cityId = 1;
  String? cityName = "Hồ Chí Minh";

  int? districtId = null;
  String? districtName = null;

  int? wardId = null;
  String? wardName = null;

  int? streetId = null;
  String? streetName = null;

  String? houseNumber = null;

  int? buildingId = null;
  String? buildingName = null;

  int? blockBuildingId = null;
  String? blockBuildingName = null;

  String fullAddress = "";

  TextEditingController _controllerSearchAddress = TextEditingController();
  TextEditingController _controllerHouseNumber = TextEditingController();
  TextEditingController _controllerBuildingName = TextEditingController();
  TextEditingController _controllerBlockBuildingName = TextEditingController();

  ChooserData? cityChooser = null;
  ChooserData? districtChooser = null;
  ChooserData? wardChooser = null;
  ChooserData? streetChooser = null;

  AnimationState _animationState = AnimationState.collapsed;
  Widget lastWidgetListSearchAddress = Container();

  bool unspecifiedLocation = false;

  List<String> listSuggestion = [];

  @override
  void initState() {
    super.initState();
    draftOffer = _propzyHomeBloc.draftOffer;
    _bloc.add(GetPropzyMapSessionEvent());
    prefHelper.getUserInfo().then((value) => userInfo = value);
    propertyType = _propzyHomeBloc.propertyTypeSelected;

    if (draftOffer?.id != null) {
      _propzyHomeBloc.add(GetOfferDetailEvent());
    }
    initObserve();

    _rubberAnimationController = RubberAnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBoundValue: AnimationControllerValue(percentage: 0.35),
      upperBoundValue: AnimationControllerValue(percentage: 0.6),
    );

    _rubberAnimationController.addStatusListener(_statusListener);
    _rubberAnimationController.animationState.addListener(_stateListener);

    _scrollControllerListSearchAddress.addListener(_listenerLoadMoreListSearch);
  }

  void _listenerLoadMoreListSearch() {
    if (_scrollControllerListSearchAddress.position.extentAfter < 50 &&
        !isLoadingMoreListSearch &&
        !isLoadAllDataSearch) {
      isLoadingMoreListSearch = true;
      currentPageSearch++;
      _bloc.add(
        SearchAddressEvent(
          _controllerSearchAddress.text,
          propertyType?.id ?? 0,
          currentPageSearch,
          10,
          null,
        ),
      );
    }
  }

  @override
  void dispose() {
    streamLocationChange.close();
    streamTextSearchChange.close();
    streamTextHouseNumberChange.close();
    _rubberAnimationController.removeStatusListener(_statusListener);
    _rubberAnimationController.animationState.removeListener(_stateListener);
    _scrollControllerListSearchAddress.removeListener(_listenerLoadMoreListSearch);
    super.dispose();
  }

  void _stateListener() {
    setState(() {
      _animationState = _rubberAnimationController.animationState.value;
    });
    print("changed state ${_rubberAnimationController.animationState.value}");
  }

  void _statusListener(AnimationStatus status) {
    print("changed status ${_rubberAnimationController.status}");
  }

  void initObserve() {
    streamLocationChange.stream.skipWhile(_skipLocationWhile)
        // .debounceTime(Duration(milliseconds: 500))
        .listen((event) {
      String lat = event["lat"].toString();
      String lng = event["lng"].toString();

      if (currentLat == "" && currentLng == "") {
      } else {
        if (currentLat != lat || currentLng != lng) {
          late PropzyMapInformation propzyMapInformation;
          if (isApartment()) {
            propzyMapInformation = PropzyMapInformation("$lat,$lng", buildingId, blockBuildingId);
          } else {
            propzyMapInformation = PropzyMapInformation("$lat,$lng", null, null);
          }

          PropzyMapInformationRequest request = PropzyMapInformationRequest(
            propertyType?.id ?? 0,
            [propzyMapInformation],
          );

          _bloc.add(GetAddressInformationEvent(request));
        }
      }

      currentLat = lat;
      currentLng = lng;
    });

    streamTextSearchChange.stream.debounceTime(Duration(milliseconds: 500)).listen((event) {
      if (propertyType?.id != null) {
        currentPageSearch = 1;
        isLoadingMoreListSearch = false;
        isLoadAllDataSearch = false;
        _bloc.add(
          SearchAddressEvent(
            event,
            propertyType?.id ?? 0,
            currentPageSearch,
            10,
            null,
          ),
        );
      }
    });

    streamTextHouseNumberChange.stream.debounceTime(Duration(milliseconds: 500)).listen((value) {
      isInputHouseNumberByKeyboard = true;
      setState(() {
        houseNumber = value;
      });
      validateInput();
    });
  }

  bool _skipLocationWhile(HashMap<String, String> element) {
    String? lat = element["lat"];
    String? lng = element["lng"];
    return currentLat == lat && currentLng == lng;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => _bloc),
        BlocProvider(create: (BuildContext context) => _propzyHomeBloc)
      ],
      child: BlocConsumer<PropzyHomeBloc, PropzyHomeState>(
        bloc: _propzyHomeBloc,
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            if (state is UpdateOfferSuccessState) {
              Util.hideLoading();
              navigateToSummary();
            } else if (state is GetOfferDetailSuccess) {
              processGetOfferDetailSuccess();
            } else if (state is SuccessCreateOfferState) {
              Util.hideLoading();
              navigateToSummary();
            } else if (state is ErrorCreateOfferState) {
              Util.hideLoading();
              Util.showMyDialog(
                context: context,
                message: state.message ?? MessageUtil.errorMessageDefault,
              );
            } else if (state is LoadingCreateOfferState) {
              Util.showLoading();
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<PickAddressBloc, PickAddressState>(
            listener: (context, state) {
              if (state is ErrorShowMessageState) {
                if (state is ErrorGetSearchAddressState) {
                  isLoadingMoreListSearch = false;
                  isLoadAllDataSearch = false;
                }
                Util.showMyDialog(
                  context: context,
                  message: state.message ?? MessageUtil.errorMessageDefault,
                );
              }
              if (state is SuccessGetAddressInformationState) {
                processGetAddressInformationSuccess(state.listAddressInformation);
                _rubberAnimationController.expand();
              }
              if (state is SuccessGetSearchAddressState) {
                _rubberAnimationController.expand();
                isLoadingMoreListSearch = false;
                isLoadAllDataSearch = currentPageSearch >= (state.totalPages ?? 1);
              }
              if (state is SuccessPredictLocationState) {
                List<String>? coordinates = state.predictLocation?.wgs84_center?.coordinates;
                if (coordinates != null && coordinates.isNotEmpty == true) {
                  currentLat = coordinates[0];
                  currentLng = coordinates[1];
                  if (currentLat.isNotEmpty && currentLng.isNotEmpty) {
                    reloadMapView(currentLat, currentLng);
                  }
                }
              }
            },
            bloc: _bloc,
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async {
                  _bloc.listSearch = null;
                  return true;
                },
                child: Scaffold(
                  body: SafeArea(
                    bottom: false,
                    child: RubberBottomSheet(
                      scrollController: _scrollController,
                      lowerLayer: _renderLowerLayer(state),
                      upperLayer: _renderUpperLayer(state),
                      animationController: _rubberAnimationController,
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

  Widget _renderLowerLayer(PickAddressState state) {
    return SizedBox.expand(
      child: Column(
        children: [
          _renderHeaderView(),
          _renderMapView(state),
        ],
      ),
    );
  }

  Widget _renderUpperLayer(PickAddressState state) {
    return !isShowBottomSheetInput
        ? _renderBottomSheetSearchAddress(state)
        : _renderBottomSheetInputAddress();
  }

  Widget _renderHeaderView() {
    return PropzyHomeHeaderView(
      onClickBack: () {
        if (isShowBottomSheetInput) {
          setState(() {
            isShowBottomSheetInput = false;
          });
          unspecifiedLocation = false;
        } else {
          _bloc.listSearch = null;
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _renderMapView(PickAddressState state) {
    if (state is LoadingGetPropzyMapSessionState) {
      lastWidgetForMapView = PropzyHomeMapView(
        state: LoadPropzyMapState.LOADING,
        getController: setControllerInAppWebView,
      );
    } else if (state is SuccessGetPropzyMapSessionState) {
      sessionMap = state.propzyMapSession?.session;
      lastWidgetForMapView = PropzyHomeMapView(
        state: LoadPropzyMapState.SUCCESS,
        session: sessionMap,
        onLocationChange: _onLocationChange,
        onLoadMapDone: (isLoadMapDone) {
          this.isLoadMapDone = isLoadMapDone;
        },
        getController: setControllerInAppWebView,
      );
    } else if (state is ErrorGetPropzyMapSessionState) {
      lastWidgetForMapView = PropzyHomeMapView(
        state: LoadPropzyMapState.ERROR,
        onClickRetry: () {
          _bloc.add(GetPropzyMapSessionEvent());
        },
        getController: setControllerInAppWebView,
      );
    }
    return lastWidgetForMapView;
  }

  setControllerInAppWebView(InAppWebViewController controller) {
    _inAppWebViewController = controller;
  }

  void _onLocationChange(String lat, String lng) {
    HashMap<String, String> hm = new HashMap();
    hm["lat"] = lat;
    hm["lng"] = lng;
    streamLocationChange.add(hm);
  }

  void reloadMapView(String? lat, String? lng) async {
    lastWidgetForMapView.lat = lat;
    lastWidgetForMapView.lng = lng;
    String url = lastWidgetForMapView.getUrl();
    await _inAppWebViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)));
  }

  Widget _renderBottomSheetSearchAddress(PickAddressState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  height: 5,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor("BBC7CD"),
                  ),
                ),
                SizedBox(height: 15),
                _renderTextSearch(),
                SizedBox(height: 15),
                _renderButtonUseMyLocation(),
                SizedBox(height: 15),
                _renderTitleSearchResult(),
                _animationState == AnimationState.expanded
                    ? Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 24),
                            _renderListSearchAddress(state),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          _renderButtonNotFoundAddress(),
        ],
      ),
    );
  }

  Widget _renderTextSearch() {
    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(116, 116, 128, 0.08),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/ic_search_gray.svg",
            width: 16,
            height: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: double.infinity,
              child: Center(
                child: TextFormField(
                  controller: _controllerSearchAddress,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.blackDefault,
                  ),
                  decoration: InputDecoration(
                    hintText: isApartment() ? "Nhập địa chỉ/ Tên chung cư" : "Nhập địa chỉ",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(60, 60, 67, 0.6),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                  ),
                  onChanged: (value) {
                    streamTextSearchChange.add(value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderButtonUseMyLocation() {
    double value = 20;
    return InkWell(
      onTap: onClickUseMyLocation,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: value,
            height: value,
            child: Stack(
              children: [
                Container(
                  width: value,
                  height: value,
                  decoration: BoxDecoration(
                    color: AppColor.orangeDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Container(
                  width: value,
                  height: value,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/ic_send_orange.svg",
                      width: value / 2,
                      height: value / 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            "Sử dụng vị trí hiện tại của tôi",
            style: TextStyle(
              color: HexColor("#EF7733"),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onClickUseMyLocation() async {
    if (isLoadMapDone) {
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
  }

  void getCurrentLocation() {
    LocationUtil.getLastKnownPosition(onSuccess: (position) {
      currentLat = "0";
      currentLng = "0";
      reloadMapView(
        position?.latitude != null ? position?.latitude.toString() : null,
        position?.longitude != null ? position?.longitude.toString() : null,
      );
    }, onError: (ex) {
      Log.e(ex);
    });
  }

  Widget _renderTitleSearchResult() {
    if (_animationState == AnimationState.expanded) {
      return Container(
        width: double.infinity,
        child: Text(
          "Kết quả tìm kiếm",
          style: TextStyle(
            color: AppColor.blackDefault,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      if (_bloc.listSearch != null) {
        return Container(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Kết quả tìm kiếm",
                style: TextStyle(
                  color: AppColor.blackDefault,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 5),
              _bloc.listSearch != null
                  ? SvgPicture.asset(
                      "assets/images/ic_double_arrow_down_grey.svg",
                      width: 16,
                      height: 16,
                    )
                  : Container(),
            ],
          ),
        );
      } else {
        return Container();
      }
    }
  }

  Widget _renderListSearchAddress(PickAddressState state) {
    if (state is LoadingGetSearchAddressState) {
      if (!state.isLoadMore) {
        lastWidgetListSearchAddress = Expanded(
          child: SizedBox.expand(
            child: Center(
              child: LoadingView(
                width: 160,
                height: 160,
              ),
            ),
          ),
        );
      }
    } else {
      if (_bloc.listSearch == null) {
        lastWidgetListSearchAddress = Container();
      } else {
        lastWidgetListSearchAddress = Expanded(
          child: ListView.builder(
            controller: _scrollControllerListSearchAddress,
            itemBuilder: _renderItemSearch,
            itemCount: _bloc.listSearch?.length,
          ),
        );
      }
    }

    return lastWidgetListSearchAddress;
  }

  Widget _renderItemSearch(BuildContext context, int index) {
    AddressSearch addressSearch = _bloc.listSearch![index];
    String address = "";
    if (isApartment()) {
      address = "${addressSearch.block_building_name} - ${addressSearch.building_name}";
      address += "\n";
      address += "${addressSearch.address}";
    } else {
      address = "${addressSearch.address}";
    }
    return InkWell(
      onTap: () {
        onClickItemAddressSearch(addressSearch);
      },
      child: Column(
        children: [
          index == 0
              ? Container()
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(
                    height: 1,
                    color: Color.fromRGBO(60, 60, 67, 0.36),
                  ),
                ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  "assets/images/ic_location_grey.svg",
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "${address}",
                    style: TextStyle(
                      color: AppColor.secondaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onClickItemAddressSearch(AddressSearch addressSearch) {
    isClickItemSuggestion = true;
    if (addressSearch.location?.isNotEmpty == true &&
        addressSearch.location?.contains(",") == true) {
      List<String> latLngStrings = addressSearch.location!.split(",");
      String lat = latLngStrings[0];
      String lng = latLngStrings[1];
      if (isApartment()) {
        buildingId = addressSearch.building_id;
        blockBuildingId = addressSearch.block_building_id;
      }

      currentLat = "0";
      currentLng = "0";

      reloadMapView(lat, lng);
    }
  }

  Widget _renderButtonNotFoundAddress() {
    if (_bloc.listSearch != null) {
      return SafeArea(
        top: false,
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: InkWell(
            onTap: () {
              setState(() {
                isShowBottomSheetInput = true;
              });
              unspecifiedLocation = true;
            },
            child: Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColor.propzyOrange),
              ),
              child: Center(
                child: Text(
                  "Không tìm thấy địa chỉ ?",
                  style: TextStyle(
                    color: AppColor.propzyOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _renderBottomSheetInputAddress() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  height: 5,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor("BBC7CD"),
                  ),
                ),
                SizedBox(height: 15),
                _renderLabelAddress(),
                SizedBox(height: 15),
                _animationState == AnimationState.expanded
                    ? Expanded(
                        child: ListView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            _renderRowFullAddress(),
                            SizedBox(height: 24),
                            _renderInputBuildingName(),
                            _renderInputBlockBuildingName(),
                            _renderInputCity(),
                            _renderInputDistrict(),
                            _renderInputWard(),
                            _renderInputStreetName(),
                            _renderInputHouseNumber(),
                            SizedBox(height: 20),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          _renderRowFullAddress(),
                          SizedBox(height: 20),
                          SvgPicture.asset(
                            "assets/images/ic_double_arrow_down_grey.svg",
                            width: 16,
                            height: 16,
                          ),
                        ],
                      ),
              ],
            ),
          ),
          _renderButtonConfirmAddress(),
        ],
      ),
    );
  }

  Widget _renderLabelAddress() {
    return Container(
      height: 37,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: HexColor(isShowLabelError ? "F8D7DA" : "FFF3CD"),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: HexColor(isShowLabelError ? "F5C6CB" : "FFEEBA")),
      ),
      child: Center(
        child: Text(
          isShowLabelError
              ? "Quý khách vui lòng điền đầy đủ các thông tin bắt buộc!"
              : "Địa chỉ nhà quý khách đã chính xác?",
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: HexColor(isShowLabelError ? "721C24" : "856404"),
          ),
        ),
      ),
    );
  }

  Widget _renderRowFullAddress() {
    fullAddress = "";
    if (isShowLabelError) {
      fullAddress = "Địa chỉ nhà của quý khách";
    } else {
      if (houseNumber?.isNotEmpty == true) {
        fullAddress += "$houseNumber ";
      }

      if (streetName?.isNotEmpty == true) {
        fullAddress += "$streetName, ";
      }

      if (wardName?.isNotEmpty == true) {
        fullAddress += "$wardName, ";
      }

      if (districtName?.isNotEmpty == true) {
        fullAddress += "$districtName, ";
      }

      if (cityName?.isNotEmpty == true) {
        fullAddress += "$cityName";
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SvgPicture.asset(
          "assets/images/ic_location_full_grey.svg",
          width: 16,
          height: 16,
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            "$fullAddress",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.secondaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  Widget _renderInputBuildingName() {
    if (isApartment()) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Tên chung cư ",
                    style: TextStyle(
                      color: getColorTitleInput(buildingName),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "*",
                    style: TextStyle(
                      color: getColorSubTitleInput(buildingName),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _controllerBuildingName,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.secondaryText,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.all(0),
              ),
              onChanged: (value) {
                setState(() {
                  buildingName = value;
                });
                validateInput();
              },
            ),
          ),
          SizedBox(height: 16),
          Divider(
            height: 1,
            color: getColorDividerInput(buildingName),
          ),
          SizedBox(height: 18),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _renderInputBlockBuildingName() {
    if (isApartment()) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Block ",
                    style: TextStyle(
                      color: getColorTitleInput(blockBuildingName),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "*",
                    style: TextStyle(
                      color: getColorSubTitleInput(blockBuildingName),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _controllerBlockBuildingName,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.secondaryText,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.all(0),
              ),
              onChanged: (value) {
                setState(() {
                  blockBuildingName = value;
                });
                validateInput();
              },
            ),
          ),
          SizedBox(height: 16),
          Divider(
            height: 1,
            color: getColorDividerInput(blockBuildingName),
          ),
          SizedBox(height: 18),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _renderInputCity() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Tỉnh/Thành ",
                  style: TextStyle(
                    color: getColorTitleInput(cityId),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: getColorSubTitleInput(cityId),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2),
        InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseCityScreen(lastChooser: cityChooser),
              ),
            );
            if (result != null) {
              final data = result[BaseChooserScreen.PARAM] as ChooserData;
              setState(() {
                cityChooser = data;
                cityId = cityChooser?.id;
                cityName = cityChooser?.name;

                districtChooser = null;
                districtId = null;
                districtName = null;

                wardChooser = null;
                wardId = null;
                wardName = null;

                streetChooser = null;
                streetId = null;
                streetName = null;
              });

              saveDraftOffer();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    "$cityName",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryText,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  "assets/images/ic_arrow_down_black.svg",
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Divider(
          height: 1,
          color: getColorDividerInput(cityId),
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _renderInputDistrict() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Quận/Huyện ",
                  style: TextStyle(
                    color: getColorTitleInput(districtId),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: getColorSubTitleInput(districtId),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2),
        InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseDistrictScreen(lastChooser: districtChooser),
              ),
            );
            if (result != null) {
              final data = result[BaseChooserScreen.PARAM] as ChooserData;
              setState(() {
                districtChooser = data;
                districtId = districtChooser?.id;
                districtName = districtChooser?.name;

                wardChooser = null;
                wardId = null;
                wardName = null;

                streetChooser = null;
                streetId = null;
                streetName = null;
              });
              saveDraftOffer();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    districtName ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryText,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  "assets/images/ic_arrow_down_black.svg",
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Divider(
          height: 1,
          color: getColorDividerInput(districtId),
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _renderInputWard() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Phường/Xã ",
                  style: TextStyle(
                    color: getColorTitleInput(wardId),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: getColorSubTitleInput(wardId),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2),
        InkWell(
          onTap: () async {
            if (districtId != null) {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChooseWardScreen(
                    lastChooser: wardChooser,
                    districtId: districtId!,
                  ),
                ),
              );
              if (result != null) {
                final data = result[BaseChooserScreen.PARAM] as ChooserData;
                setState(() {
                  wardChooser = data;
                  wardId = wardChooser?.id;
                  wardName = wardChooser?.name;

                  streetChooser = null;
                  streetId = null;
                  streetName = null;
                });

                saveDraftOffer();
              }
            } else {
              Util.showMyDialog(
                context: context,
                message: "Vui lòng chọn Quận/Huyện",
              );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    wardName ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryText,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  "assets/images/ic_arrow_down_black.svg",
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Divider(
          height: 1,
          color: getColorDividerInput(wardId),
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _renderInputStreetName() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Tên đường ",
                  style: TextStyle(
                    color: getColorTitleInput(streetId),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: getColorSubTitleInput(streetId),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2),
        InkWell(
          onTap: () async {
            if (wardId != null) {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChooseStreetScreen(
                    lastChooser: streetChooser,
                    wardId: wardId!,
                  ),
                ),
              );
              if (result != null) {
                final data = result[BaseChooserScreen.PARAM] as ChooserData;
                setState(() {
                  streetChooser = data;
                  streetId = streetChooser?.id;
                  streetName = streetChooser?.name;
                });

                saveDraftOffer();
                _bloc.add(PredictLocationEvent(streetId ?? 0));
              }
            } else {
              Util.showMyDialog(
                context: context,
                message: "Vui lòng chọn Phường/Xã",
              );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    streetName ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryText,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  "assets/images/ic_arrow_down_black.svg",
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Divider(
          height: 1,
          color: getColorDividerInput(streetId),
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _renderInputHouseNumber() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Số nhà ",
                  style: TextStyle(
                    color: getColorTitleInput(houseNumber),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: getColorSubTitleInput(houseNumber),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2),
        SuggestionHouseNumberTextField(
          initialHouseNumber: houseNumber,
          streamTextHouseNumberChange: streamTextHouseNumberChange,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.all(0),
          ),
          onClickItemSuggestion: (searchAddressWithStreet) {
            List<String>? coordinates = searchAddressWithStreet.wgs84_center?.coordinates;
            if ((coordinates?.length ?? 0) > 1) {
              currentLat = coordinates?.elementAt(0) ?? currentLat;
              currentLng = coordinates?.elementAt(1) ?? currentLng;
              reloadMapView(currentLat, currentLng);
            }
            houseNumber = searchAddressWithStreet.house_number;
            validateInput();
            saveDraftOffer();
          },
        ),
        SizedBox(height: 8),
        Divider(
          height: 1,
          color: getColorDividerInput(houseNumber),
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _renderButtonConfirmAddress() {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.only(top: 15),
        child: PropzyHomeContinueButton(
          isEnable: !isShowLabelError,
          height: 48,
          content: "Đã chính xác",
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          onClick: () {
            saveDraftOffer();
            createOrUpdateOffer();
          },
        ),
      ),
    );
  }

  void validateInput() {
    bool isNullValueForApartment = false;
    if (isApartment()) {
      isNullValueForApartment = (buildingName == null || buildingName?.isEmpty == true) ||
          (blockBuildingName == null || buildingName?.isEmpty == true);
    }

    isShowLabelError = isNullValueForApartment ||
        cityId == null ||
        districtId == null ||
        wardId == null ||
        streetId == null ||
        (houseNumber == null || houseNumber?.isEmpty == true);
    setState(() {
      isShowLabelError = isShowLabelError;
    });
  }

  Color getColorTitleInput(dynamic value) {
    if (value.runtimeType == int) {
      return value != null ? HexColor("555555") : HexColor("C93400");
    } else {
      return value?.isNotEmpty == true ? HexColor("555555") : HexColor("C93400");
    }
  }

  Color getColorSubTitleInput(dynamic value) {
    if (value.runtimeType == int) {
      return value != null ? HexColor("c11e1c") : HexColor("C93400");
    } else {
      return value?.isNotEmpty == true ? HexColor("c11e1c") : HexColor("C93400");
    }
  }

  Color getColorDividerInput(dynamic value) {
    if (value.runtimeType == int) {
      return value != null ? Color.fromRGBO(60, 60, 67, 0.36) : HexColor("C93400");
    } else {
      return value?.isNotEmpty == true ? Color.fromRGBO(60, 60, 67, 0.36) : HexColor("C93400");
    }
  }

  bool isApartment() {
    return propertyType?.id == PROPERTY_TYPES.CHUNG_CU.type;
  }

  void processGetAddressInformationSuccess(List<AddressInformation>? listAddressInformation) async {
    if ((listAddressInformation?.length ?? 0) > 0) {
      AddressInformation addressInformation = listAddressInformation![0];
      cityId = addressInformation.city_id;
      districtId = addressInformation.district_id;
      wardId = addressInformation.ward_id;
      streetId = addressInformation.street_id;

      if (isApartment()) {
        buildingId = addressInformation.building_id;
        buildingName = addressInformation.building_name;
        blockBuildingId = addressInformation.block_building_id;
        blockBuildingName = addressInformation.block_building_name;

        _controllerBuildingName.value = TextEditingValue(text: buildingName ?? "");
        _controllerBlockBuildingName.value = TextEditingValue(text: blockBuildingName ?? "");
      }

      if (addressInformation.province_name?.isNotEmpty == true) {
        cityName = addressInformation.province_name;
      } else {
        if (cityId == null) {
          cityName = "";
        } else {
          cityName = "Hồ Chí Minh";
        }
      }

      if (addressInformation.district_name?.isNotEmpty == true) {
        districtName = addressInformation.district_name;
      } else {
        if (districtId == null) {
          districtName = null;
        } else {
          districtName = (await _bloc.getDistrictById(districtId!))?.districtName;
        }
      }

      if (addressInformation.ward_name?.isNotEmpty == true) {
        wardName = addressInformation.ward_name;
      } else {
        if (wardId == null) {
          wardName = null;
        } else {
          wardName = (await _bloc.getWardById(wardId!))?.wardName;
        }
      }

      if (addressInformation.street_name?.isNotEmpty == true) {
        streetName = addressInformation.street_name;
      } else {
        if (streetId == null) {
          streetName = null;
        } else {
          streetName = (await _bloc.getStreetById(streetId!))?.streetName;
        }
      }

      if (isClickItemSuggestion) {
        _controllerHouseNumber.value = TextEditingValue(text: addressInformation.so_nha ?? "");
      } else if (isInputHouseNumberByKeyboard) {
        _controllerHouseNumber.value = TextEditingValue(text: houseNumber ?? "");
      } else {
        _controllerHouseNumber.value = TextEditingValue(text: "");
      }
      houseNumber = _controllerHouseNumber.text;
      isShowBottomSheetInput = true;

      districtChooser = ChooserData(districtId, districtName);
      wardChooser = ChooserData(wardId, wardName);
      streetChooser = ChooserData(streetId, streetName);

      setState(() {});
      validateInput();
    }
    isClickItemSuggestion = false;
  }

  void saveDraftOffer() {
    if (draftOffer == null) {
      draftOffer = HomeOfferModel();
    }

    draftOffer?.address = fullAddress;
    draftOffer?.cityId = cityId;
    draftOffer?.districtId = districtId;
    draftOffer?.wardID = wardId;
    draftOffer?.streetId = streetId;
    draftOffer?.houseNumber = houseNumber;
    draftOffer?.unspecifiedLocation = unspecifiedLocation;
    draftOffer?.buildingId = buildingId;
    draftOffer?.buildingName = buildingName;
    draftOffer?.blockBuildingId = blockBuildingId;
    draftOffer?.blockBuildingName = blockBuildingName;
    draftOffer?.latitude = double.tryParse(currentLat);
    draftOffer?.longitude = double.tryParse(currentLng);

    _propzyHomeBloc.add(SaveDraftOfferEvent(draftOffer));
  }

  void createOrUpdateOffer() {
    int? reachedPageId = _propzyHomeBloc.getReachedPageId(SCREEN_PAGE_CODE);
    PropzyHomePropertyType? propertyTypeSelected = _propzyHomeBloc.propertyTypeSelected;
    if (_propzyHomeBloc.draftOffer?.id != null) {
      // update offer
      final event = UpdateOfferEvent(
        reachedPageId: reachedPageId,
        contactName: draftOffer?.contactName,
        contactPhone: draftOffer?.contactPhone,
        contactEmail: draftOffer?.contactEmail,
        latitude: draftOffer?.latitude,
        longitude: draftOffer?.longitude,
        cityId: draftOffer?.cityId,
        districtId: draftOffer?.districtId,
        address: draftOffer?.address,
        wardID: draftOffer?.wardID,
        streetId: draftOffer?.streetId,
        houseNumber: draftOffer?.houseNumber,
        unspecifiedLocation: draftOffer?.unspecifiedLocation,
        blockBuildingId: draftOffer?.blockBuildingId,
        blockBuildingName: draftOffer?.blockBuildingName,
        buildingId: draftOffer?.buildingId,
        buildingName: draftOffer?.buildingName,
        propertyTypeId: propertyTypeSelected?.id,
      );
      _propzyHomeBloc.add(event);
    } else {
      // create offer
      PropzyHomeCreateOfferRequest request = PropzyHomeCreateOfferRequest()
        ..userId = userInfo?.socialUid
        ..propertyTypeId = propertyTypeSelected?.id
        ..latitude = draftOffer?.latitude
        ..contactName = userInfo?.name
        ..contactPhone = userInfo?.phone
        ..longitude = draftOffer?.longitude
        ..cityId = draftOffer?.cityId
        ..districtId = draftOffer?.districtId
        ..address = draftOffer?.address
        ..wardID = draftOffer?.wardID
        ..streetId = draftOffer?.streetId
        ..houseNumber = draftOffer?.houseNumber
        ..unspecifiedLocation = draftOffer?.unspecifiedLocation
        ..blockBuildingId = draftOffer?.blockBuildingId
        ..blockBuildingName = draftOffer?.blockBuildingName
        ..buildingId = draftOffer?.buildingId
        ..buildingName = draftOffer?.buildingName
        ..reachedPageId = reachedPageId
        ..currentPage = reachedPageId;

      _propzyHomeBloc.add(CreateOfferEvent(request));
    }
  }

  void navigateToSummary() {
    NavigationController.navigateToIBuySummary(context);
  }

  void processGetOfferDetailSuccess() async {
    draftOffer = _propzyHomeBloc.draftOffer;
    cityId = 1;
    cityName = "Hồ Chí Minh";

    districtId = draftOffer?.districtId;
    if (districtId == null) {
      districtName = "";
    } else {
      districtName = (await _bloc.getDistrictById(districtId!))?.districtName;
    }

    wardId = draftOffer?.wardID;
    if (wardId == null) {
      wardName = "";
    } else {
      wardName = (await _bloc.getWardById(wardId!))?.wardName;
    }

    streetId = draftOffer?.streetId;
    if (streetId == null) {
      streetName = "";
    } else {
      streetName = (await _bloc.getStreetById(streetId!))?.streetName;
    }

    if (isApartment()) {
      buildingId = draftOffer?.buildingId;
      buildingName = draftOffer?.buildingName;
      _controllerBuildingName.value = TextEditingValue(text: buildingName ?? "");

      blockBuildingId = draftOffer?.blockBuildingId;
      blockBuildingName = draftOffer?.blockBuildingName;
      _controllerBlockBuildingName.value = TextEditingValue(text: blockBuildingName ?? "");
    }

    houseNumber = draftOffer?.houseNumber;
    _controllerHouseNumber.value = TextEditingValue(text: houseNumber ?? "");

    isShowBottomSheetInput = true;
    _rubberAnimationController.expand();

    if (draftOffer?.latitude != null && draftOffer?.longitude != null) {
      currentLat = "${draftOffer?.latitude}";
      currentLng = "${draftOffer?.longitude}";
      reloadMapView(currentLat, currentLng);
    }
    validateInput();
    setState(() {});
  }
}
