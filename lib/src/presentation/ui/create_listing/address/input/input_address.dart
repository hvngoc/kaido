import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/model/ward.dart';
import 'package:propzy_home/src/libs/easy_autocomplete/easy_autocomplete.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_city/choose_city_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_district/choose_district_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_street/choose_street_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_ward/choose_ward_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/input/bloc/input_address_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/input/bloc/input_address_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/input/bloc/input_address_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/suggestion_house_number_view.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/location_util.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:rxdart/rxdart.dart';

class InputAddressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InputAddressScreenState();
}

class _InputAddressScreenState extends State<InputAddressScreen> {
  final CreateListingBloc _createListingBloc = GetIt.instance.get<CreateListingBloc>();
  final InputAddressBloc _inputAddressBloc = GetIt.instance.get<InputAddressBloc>();
  final String currentStep = "ADDRESS_STEP";

  int? cityId = 1;
  String? cityName = "Hồ Chí Minh";

  int? districtId = null;
  String? districtName = "";

  int? wardId = null;
  String? wardName = "";

  int? streetId = null;
  String? streetName = "";

  String? houseNumber = "";

  ChooserData? cityChooser = null;
  ChooserData? districtChooser = null;
  ChooserData? wardChooser = null;
  ChooserData? streetChooser = null;
  String? currentLat = "";
  String? currentLng = "";

  bool isHideHouseNumber = false;
  Subject<String> streamTextHouseNumberChange = PublishSubject();
  TextEditingController _controllerSearch = TextEditingController();
  TextEditingController _controllerHouseNumber = TextEditingController();

  @override
  void dispose() {
    streamTextHouseNumberChange.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (_createListingBloc.createListingRequest?.id != null) {
      _createListingBloc
          .add(GetDraftListingDetailEvent(_createListingBloc.createListingRequest!.id!));
    }

    streamTextHouseNumberChange.stream.debounceTime(Duration(milliseconds: 500)).listen((value) {
      setState(() {
        houseNumber = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _inputAddressBloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: BlocConsumer<CreateListingBloc, BaseCreateListingState>(
        bloc: _createListingBloc,
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            if (state is ListingLoadingState) {
              Util.showLoading();
            } else if (state is ErrorMessageState) {
              Util.hideLoading();
              Util.showMyDialog(
                context: context,
                message: state.errorMessage ?? MessageUtil.errorMessageDefault,
              );
            } else if (state is GetDraftListingDetailSuccessState) {}
          }
        },
        builder: (context, state) {
          return BlocConsumer<InputAddressBloc, InputAddressState>(
            bloc: _inputAddressBloc,
            listener: (context, state) {
              if (state is ErrorState) {
                Util.hideLoading();
                Util.showMyDialog(
                  context: context,
                  message: state.message ?? MessageUtil.errorMessageDefault,
                );
              } else if (state is LoadingState) {
                Util.showLoading();
              } else if (state is SuccessGetAddressInformationState) {
                AddressByLocation? addressByLocation = state.addressByLocation;
                houseNumber = addressByLocation?.houseNumber;
                _controllerHouseNumber.value = TextEditingValue(text: houseNumber ?? "");

                setState(() {
                  cityId = addressByLocation?.cityId;
                  cityName = addressByLocation?.cityName;
                  cityChooser = ChooserData(cityId, cityName);

                  districtId = addressByLocation?.districtId;
                  districtName = addressByLocation?.districtName;
                  districtChooser = ChooserData(districtId, districtName);

                  wardId = addressByLocation?.wardId;
                  wardName = addressByLocation?.wardName;
                  wardChooser = ChooserData(wardId, wardName);

                  streetId = addressByLocation?.streetId;
                  streetName = addressByLocation?.streetName;
                  streetChooser = ChooserData(streetId, streetName);
                });
                Util.hideLoading();
              } else if (state is SuccessPredictLocationState) {
                List<String>? coordinates = state.predictLocation?.wgs84_center?.coordinates;
                if (coordinates != null && coordinates.isNotEmpty == true) {
                  currentLat = coordinates[0];
                  currentLng = coordinates[1];
                }
              } else if (state is SuccessUpdateAddressState) {
                Util.hideLoading();
                navigateToConfirmMapAddress();
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: PropzyAppBar(
                  title: 'Đăng tin bất động sản',
                  onBack: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      // _renderHeaderBar(),
                      // SizedBox(height: 24),
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

  Widget _renderHeaderBar() {
    return HeaderBarView();
  }

  Widget _renderProgressBar() {
    return CreateListingProgressBarView(
      currentStep: 1,
      currentScreenInStep: 1,
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
          "Địa chỉ bất động sản của bạn",
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
          "Thông tin chính xác giúp khách hàng tìm đến bạn dễ dàng hơn",
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
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          _renderInputSearch(),
          SizedBox(height: 20),
          _renderRowCityAndDistrict(),
          SizedBox(height: 16),
          _renderRowWard(),
          SizedBox(height: 16),
          _renderRowStreetName(),
          SizedBox(height: 16),
          _renderRowHouseNumber(),
          SizedBox(height: 16),
          _renderRowCheckBox(),
        ],
      ),
    );
  }

  Widget _renderFooter() {
    bool isEnable = cityId != null &&
        districtId != null &&
        wardId != null &&
        streetName?.isNotEmpty == true &&
        houseNumber?.isNotEmpty == true;

    return PropzyHomeContinueButton(
      isEnable: isEnable,
      fontWeight: FontWeight.w700,
      onClick: () async {
        if (_createListingBloc.createListingRequest == null) {
          _createListingBloc.createListingRequest =
              CreateListingRequest(isHideHouseNumber: isHideHouseNumber);
        }

        _createListingBloc.createListingRequest?.cityId = cityId;
        _createListingBloc.createListingRequest?.districtId = districtId;
        _createListingBloc.createListingRequest?.wardId = wardId;
        _createListingBloc.createListingRequest?.streetId = streetId;
        _createListingBloc.createListingRequest?.streetName = streetName;
        _createListingBloc.createListingRequest?.address =
            "${houseNumber ?? ""} ${streetName ?? ""}, ${wardName ?? ""}, ${districtName ?? ""}, ${cityName ?? ""} ";
        _createListingBloc.createListingRequest?.latitude = double.tryParse(currentLat ?? "");
        _createListingBloc.createListingRequest?.longitude = double.tryParse(currentLng ?? "");
        _createListingBloc.createListingRequest?.sourceId =
            Constants.CREATE_LISTING_SOURCE_ID_FOR_PROPZY_APP;
        _createListingBloc.createListingRequest?.currentStep = currentStep;

        if (_createListingBloc.createListingRequest?.id != null) {
          _inputAddressBloc
              .add(UpdateListingAddressEvent(_createListingBloc.createListingRequest!));
        } else {
          navigateToConfirmMapAddress();
        }
      },
    );
  }

  Widget _renderInputSearch() {
    return Container(
      height: 54,
      child: EasyAutocomplete(
        decoration: InputDecoration(
          hintText: "Tìm nhanh địa chỉ BĐS của bạn",
          hintStyle: TextStyle(
            color: HexColor("4A4A4A"),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          isDense: true,
          contentPadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 10),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: SvgPicture.asset(
              "assets/images/ic_magnifying.svg",
              width: 24,
              height: 24,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: HexColor("DBDBDB"),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: HexColor("DBDBDB"),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: HexColor("DBDBDB"),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: HexColor("DBDBDB"),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        asyncSuggestions: (searchValue) async =>
            _inputAddressBloc.searchAddressSuggestion(searchValue),
        debounceDuration: Duration(milliseconds: 500),
        progressIndicatorBuilder: LoadingView(
          width: 160,
          height: 160,
        ),
        controller: _controllerSearch,
        onChanged: (value) {
          if (value != "Vị trí hiện tại của bạn") {
            _controllerSearch
              ..value = TextEditingValue(
                  text: value, selection: TextSelection.collapsed(offset: value.length));
          }
        },
        onSubmitted: (value) {
          onSelectItemSearchSuggestion(value);
        },
        suggestionBuilder: (data, index) {
          return Container(
            child: Column(
              children: [
                index == 0 ? Container() : Divider(height: 0.5, color: AppColor.grayD8),
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/${data == "Vị trí hiện tại của bạn" ? "ic_get_current_location" : "vector_ic_geo"}.svg",
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          data,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColor.blackDefault,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _renderRowCityAndDistrict() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _renderInputSelect(
            title: "Thành phố",
            hint: "Chọn Thành phố",
            value: cityName ?? "",
            isRequire: true,
            onTap: () {
              clickOnChooseCity();
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: _renderInputSelect(
            title: "Quận/Huyện",
            hint: "Chọn Quận/Huyện",
            value: districtName ?? "",
            isRequire: true,
            onTap: () {
              clickOnChooseDistrict();
            },
          ),
        ),
      ],
    );
  }

  Widget _renderRowWard() {
    return Container(
      child: _renderInputSelect(
        title: "Phường/Xã",
        hint: "Chọn Phường/Xã",
        value: wardName ?? "",
        isRequire: true,
        onTap: () {
          clickOnChooseWard();
        },
      ),
    );
  }

  Widget _renderRowStreetName() {
    return Container(
      child: _renderInputSelect(
        title: "Tên đường",
        hint: "Nhập tên đường",
        value: streetName ?? "",
        isRequire: true,
        onTap: () {
          clickOnChooseStreet();
        },
      ),
    );
  }

  Widget _renderRowHouseNumber() {
    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: houseNumber?.isNotEmpty == true ? HexColor("DEE1E2") : HexColor("D6180C"),
        width: 1,
      ),
    );

    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Số nhà",
                    style: TextStyle(
                      color: AppColor.secondaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: " *",
                    style: TextStyle(
                      color: HexColor("DD3E3A"),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(height: 10),
        Container(
          height: 42,
          child: SuggestionHouseNumberTextField(
            controller: _controllerHouseNumber,
            initialHouseNumber: houseNumber,
            streamTextHouseNumberChange: streamTextHouseNumberChange,
            streetId: streetId,
            decoration: InputDecoration(
              hintText: "Nhập số nhà",
              hintStyle: TextStyle(
                color: HexColor("4A4A4A"),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              isDense: true,
              contentPadding: EdgeInsets.all(12),
              focusedBorder: border,
              enabledBorder: border,
              disabledBorder: border,
            ),
            onClickItemSuggestion: (searchAddressWithStreet) {
              List<String>? coordinates = searchAddressWithStreet.wgs84_center?.coordinates;
              if ((coordinates?.length ?? 0) > 1) {
                currentLat = coordinates?.elementAt(0) ?? currentLat;
                currentLng = coordinates?.elementAt(1) ?? currentLng;
              }
              setState(() {
                houseNumber = searchAddressWithStreet.house_number;
              });
            },
          ),
        ),
        SizedBox(height: 5),
        // houseNumber?.isNotEmpty == true
        //     ? Container(
        //         height: 17,
        //       )
        //     : Container(
        //         width: double.infinity,
        //         height: 17,
        //         child: Text(
        //           "Thông tin bắt buộc",
        //           style: TextStyle(
        //             color: HexColor("D6180C"),
        //             fontSize: 14,
        //             fontWeight: FontWeight.w400,
        //           ),
        //         ),
        //       )
      ],
    );
  }

  Widget _renderRowCheckBox() {
    return Container(
      height: 30,
      child: InkWellWithoutRipple(
        onTap: () {
          setState(() {
            isHideHouseNumber = !isHideHouseNumber;
          });
        },
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/images/${isHideHouseNumber ? "ic_checked_blue.svg" : "ic_unchecked_gray.svg"}",
              width: 16,
              height: 16,
            ),
            SizedBox(width: 8),
            Text(
              "Không hiển thị số nhà trên tin đăng",
              style: TextStyle(
                color: AppColor.blackDefault,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderInputSelect({
    required String title,
    required String value,
    required String hint,
    required bool isRequire,
    bool isInputField = false,
    GestureTapCallback? onTap,
    ValueChanged<String>? onChanged,
  }) {
    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: isRequire && value.isEmpty ? HexColor("D6180C") : HexColor("DEE1E2"),
        width: 1,
      ),
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          child: isRequire
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyle(
                          color: AppColor.secondaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: " *",
                        style: TextStyle(
                          color: HexColor("DD3E3A"),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                    color: AppColor.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        SizedBox(height: 10),
        isInputField
            ? Container(
                height: 42,
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    onChanged?.call(value);
                  },
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: HexColor("4A4A4A"),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.all(12),
                    focusedBorder: border,
                    enabledBorder: border,
                    disabledBorder: border,
                  ),
                ),
              )
            : InkWell(
                onTap: () {
                  onTap?.call();
                },
                child: Container(
                  height: 42,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isRequire && value.isEmpty ? HexColor("D6180C") : HexColor("DEE1E2"),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          value.isNotEmpty ? value : hint,
                          style: TextStyle(
                            color: HexColor("4A4A4A"),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        width: 28,
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/images/ic_arrow_down_gray.svg",
                            width: 12,
                            height: 7,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        SizedBox(height: 5),
        // isRequire && value.isEmpty
        //     ? Container(
        //         width: double.infinity,
        //         height: 17,
        //         child: Text(
        //           "Thông tin bắt buộc",
        //           style: TextStyle(
        //             color: HexColor("D6180C"),
        //             fontSize: 14,
        //             fontWeight: FontWeight.w400,
        //           ),
        //         ),
        //       )
        //     : Container(
        //         height: 17,
        //       )
      ],
    );
  }

  void clickOnChooseCity() async {
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
    }
  }

  void clickOnChooseDistrict() async {
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
    }
  }

  void clickOnChooseWard() async {
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

        Ward? ward = await _inputAddressBloc.getWardById(wardId ?? 0);
        currentLat = ward?.latitude?.toString();
        currentLng = ward?.longitude?.toString();
      }
    } else {
      Util.showMyDialog(
        context: context,
        message: "Vui lòng chọn Quận/Huyện",
      );
    }
  }

  void clickOnChooseStreet() async {
    if (wardId != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseStreetScreen(
            lastChooser: streetChooser,
            wardId: wardId!,
            canAddMoreData: true,
            textAddMore: "Thêm mới",
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

        _inputAddressBloc.add(PredictLocationEvent(streetId ?? 0));
      }
    } else {
      Util.showMyDialog(
        context: context,
        message: "Vui lòng chọn Phường/Xã",
      );
    }
  }

  void onSelectItemSearchSuggestion(String value) async {
    List<SearchAddress> listSuggestion = _inputAddressBloc.listSuggestion.toList();
    int indexSelected = listSuggestion.lastIndexWhere((element) => element.address == value);
    if (indexSelected != -1) {
      SearchAddress searchAddress = listSuggestion[indexSelected];
      if (searchAddress.isFakeLocation) {
        await onClickUseMyLocation();
      } else {
        if (searchAddress.location != null) {
          if (searchAddress.location!.contains(",")) {
            List<String> coordinates = searchAddress.location!.split(",");
            if (coordinates.length > 1) {
              currentLat = coordinates[0];
              currentLng = coordinates[1];
            }
          }
          _inputAddressBloc.add(GetLocationInformationEvent(searchAddress.location!));
        }
      }
    }
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
      if (position?.latitude != null && position?.longitude != null) {
        currentLat = position?.latitude.toString();
        currentLng = position?.longitude.toString();
        _inputAddressBloc.add(
          GetLocationInformationEvent("${position?.latitude},${position?.longitude}"),
        );
      }
    }, onError: (ex) {
      Log.e(ex);
    });
  }

  void navigateToConfirmMapAddress() {
    NavigationController.navigateToConfirmMapAddressCreateListing(context);
  }
}
