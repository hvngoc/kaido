import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_city/choose_city_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_district/choose_district_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_ward/choose_ward_widget.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_header_only.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_price.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_10/bloc/Step10Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_10/data/address_list_ward.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class HomeInformationStep10 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step10State();
}

class _Step10State extends State<HomeInformationStep10> {
  final Step10Bloc bloc = GetIt.instance.get<Step10Bloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  List<AddressListWard> listAddress = [];

  int? expectedPriceFrom = null;
  int? expectedPriceFromInit = null;
  int? expectedPriceTo = null;
  int? expectedPriceToInit = null;

  bool isCheckHome = true;
  bool isCheckApartment = false;

  @override
  void initState() {
    super.initState();
    _propzyHomeBloc.add(GetOfferDetailEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => bloc),
        BlocProvider(create: (_) => _propzyHomeBloc),
      ],
      child: BlocConsumer<PropzyHomeBloc, PropzyHomeState>(
        bloc: _propzyHomeBloc,
        listener: (context, state) async {
          if (ModalRoute.of(context)?.isCurrent == true) {
            if (state is UpdateOfferSuccessState) {
              final offerId = _propzyHomeBloc.draftOffer?.id;
              if (offerId != null) {
                NavigationController.navigateToLoadingProcessRequest(context, offerId);
              }
            } else if (state is GetOfferDetailSuccess) {
              final plan = _propzyHomeBloc.draftOffer?.planning;
              if (plan == null) {
                return;
              }
              expectedPriceFrom = plan.priceFrom?.toInt();
              expectedPriceFromInit = plan.priceFrom?.toInt();
              expectedPriceTo = plan.priceTo?.toInt();
              expectedPriceToInit = plan.priceTo?.toInt();
              isCheckHome = plan.propertyTypeId == PROPERTY_TYPES.NHA_RIENG.type ||
                  plan.propertyTypeId == null;
              isCheckApartment = plan.propertyTypeId == PROPERTY_TYPES.CHUNG_CU.type;
              listAddress = await bloc.prepareDistrict(plan);
              setState(() {});
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    PropzyHomeHeaderView(isLoadOfferDetail: true),
                    if (_propzyHomeBloc.draftOffer?.id != null)
                      PropzyHomeProgressPage(
                        offerId: _propzyHomeBloc.draftOffer!.id!,
                      ),
                    SizedBox(height: 30),
                    Text(
                      'Thông tin BĐS bạn đang quan tâm',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColor.blackDefault,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Thông tin này giúp Propzy thấu hiểu nhu cầu và gửi danh sách BĐS phù hợp nhất. Bạn có thể điều chỉnh và ngừng nhận tin bất kỳ lúc nào.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.propzyHomeDes,
                      ),
                    ),
                    SizedBox(height: 40),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 10, left: 6, right: 6),
                        physics: ClampingScrollPhysics(),
                        children: [
                          FieldTextHeaderOnly(
                            title: 'Loại hình BĐS',
                            images: 'assets/images/vector_ic_property_type.svg',
                          ),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isCheckHome = true;
                                    isCheckApartment = false;
                                  });
                                },
                                child: Container(
                                  height: 48,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(isCheckHome
                                          ? "assets/images/vector_ic_type_properties_checked.svg"
                                          : "assets/images/vector_ic_type_properties_normal.svg"),
                                      SizedBox(width: 8),
                                      Text(
                                        'Nhà riêng',
                                        style: TextStyle(
                                          color: AppColor.blackDefault,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 50),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isCheckApartment = true;
                                    isCheckHome = false;
                                  });
                                },
                                child: Container(
                                  height: 48,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(isCheckApartment
                                          ? "assets/images/vector_ic_type_properties_checked.svg"
                                          : "assets/images/vector_ic_type_properties_normal.svg"),
                                      SizedBox(width: 6),
                                      Text(
                                        'Căn hộ',
                                        style: TextStyle(
                                          color: AppColor.blackDefault,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          FieldTextHeaderOnly(
                            title: 'Khu vực',
                            images: 'assets/images/vector_ic_check_in.svg',
                          ),
                          SizedBox(height: 4),
                          Material(
                            color: AppColor.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                width: 1,
                                color: AppColor.grayC6,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChooseCityScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 48,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 6),
                                    Text(
                                      'TP. Hồ Chí Minh',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColor.secondaryText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColor.gray7D,
                                      size: 20,
                                    ),
                                    SizedBox(width: 4),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColor.grayC6),
                            ),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _generateListDistrict(),
                            ),
                          ),
                          SizedBox(height: 16),
                          Visibility(
                            visible: listAddress.length > 0,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: listAddress.length,
                              itemBuilder: (context, index) {
                                return _buildSectionWard(index);
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 16);
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          FieldTextHeaderOnly(
                            title: 'Khoảng giá',
                            images: 'assets/images/vector_ic_price_plan.svg',
                          ),
                          FieldTextPrice(
                            titleHeader: 'Giá từ',
                            hint: 'Nhập giá từ',
                            unit: 'VNĐ',
                            initValue: expectedPriceFromInit?.toString(),
                            lastValue: expectedPriceFrom?.toString(),
                            onChange: (e) {
                              expectedPriceFrom = e;
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 20),
                          FieldTextPrice(
                            titleHeader: 'Giá đến',
                            hint: 'Nhập giá đến',
                            unit: 'VNĐ',
                            initValue: expectedPriceToInit?.toString(),
                            lastValue: expectedPriceTo?.toString(),
                            onChange: (e) {
                              expectedPriceTo = e;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    PropzyHomeContinueButton(
                      isEnable: isSelected(),
                      height: 50,
                      onClick: () {
                        if (expectedPriceTo! < expectedPriceFrom!) {
                          Util.showMyDialog(
                            context: context,
                            message: 'Vui lòng nhập ‘giá đến’ phải lớn hơn ‘giá từ’',
                          );
                        } else {
                          final reachedPage = _propzyHomeBloc
                              .getReachedPageId(PropzyHomeScreenDirect.PLAN_INFO.pageCode);
                          final List<PropzyHomeOfferDistrict> districts = [];
                          final List<PropzyHomeOfferWard> wards = [];
                          listAddress.forEach((d) {
                            final district = PropzyHomeOfferDistrict(
                              cityId: 1,
                              districtId: d.district.data.id,
                              preferred: d.district.isFavorite,
                            );
                            districts.add(district);
                            final ward = d.listWard.map((w) => PropzyHomeOfferWard(
                                  districtId: d.district.data.id,
                                  wardId: w.data.id,
                                  preferred: w.isFavorite,
                                ));
                            wards.addAll(ward);
                          });
                          final event = UpdateOfferEvent(
                              reachedPageId: reachedPage,
                              planning: PropzyHomeOfferPlanning(
                                propertyTypeId: isCheckHome
                                    ? PROPERTY_TYPES.NHA_RIENG.type
                                    : PROPERTY_TYPES.CHUNG_CU.type,
                                priceFrom: expectedPriceFrom?.toDouble(),
                                priceTo: expectedPriceTo?.toDouble(),
                                cities: [PropzyHomeOfferCity(cityId: 1, preferred: true)],
                                districts: districts,
                                wards: wards,
                              ));
                          _propzyHomeBloc.add(event);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isSelected() {
    return expectedPriceFrom != null &&
        expectedPriceTo != null &&
        (isCheckHome || isCheckApartment);
  }

  Widget _buildSectionWard(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColor.grayE4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            color: AppColor.grayF0,
            child: Text(
              listAddress[index].district.data.name ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.blackDefault,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _generateChildWard(index),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _generateChildWard(int index) {
    final current = listAddress[index];
    final buttonMore = _buildButtonAddMore('Thêm phường', () async {
      final wards = current.listWard.map((e) => e.data).toList();
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseWardScreen(
            listChooser: wards,
            districtId: current.district.data.id!,
          ),
        ),
      );
      final data = result[BaseChooserScreen.PARAM] as ChooserData;
      if (!current.listWard.any((e) => e.data.id == data.id)) {
        current.listWard.add(AddressChooser(data, false));
        setState(() {});
      }
    });
    List<Widget> results = [];
    results.add(buttonMore);
    final address = current.listWard.map((e) => _buildButtonAddress(
          e.data.name,
          e.isFavorite,
          () {
            current.listWard.remove(e);
            setState(() {});
          },
          () {
            if (!current.district.isFavorite) {
              return;
            }
            final last = e.isFavorite;
            current.listWard.forEach((element) {
              element.isFavorite = false;
            });
            e.isFavorite = !last;
            setState(() {});
          },
        ));
    results.addAll(address);
    return results;
  }

  List<Widget> _generateListDistrict() {
    final buttonMore = _buildButtonAddMore('Thêm quận', () async {
      final districts = listAddress.map((e) => e.district.data).toList();
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseDistrictScreen(listChooser: districts),
        ),
      );
      final data = result[BaseChooserScreen.PARAM] as ChooserData;
      if (!listAddress.any((e) => e.district.data.id == data.id)) {
        final address = AddressListWard(AddressChooser(data, false), listWard: []);
        listAddress.add(address);
        setState(() {});
      }
    });
    List<Widget> results = [];
    results.add(buttonMore);
    final address = listAddress.map((e) => _buildButtonAddress(
          e.district.data.name,
          e.district.isFavorite,
          () {
            listAddress.remove(e);
            setState(() {});
          },
          () {
            final last = e.district.isFavorite;
            listAddress.forEach((d) {
              d.district.isFavorite = false;
              d.listWard.forEach((w) {
                w.isFavorite = false;
              });
            });
            e.district.isFavorite = !last;
            setState(() {});
          },
        ));
    results.addAll(address);
    return results;
  }

  Widget _buildButtonAddress(
    String? _text,
    bool isFavorite,
    GestureTapCallback _onTapClose,
    GestureTapCallback _onTapFavorite,
  ) {
    return Material(
      color: AppColor.grayF5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        height: 38,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkResponse(
              radius: 16,
              onTap: _onTapFavorite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SvgPicture.asset(isFavorite
                    ? 'assets/images/vector_ic_tag_star_selected.svg'
                    : 'assets/images/vector_ic_tag_star_normal.svg'),
              ),
            ),
            Text(
              _text ?? '',
              style: TextStyle(
                color: AppColor.blackDefault,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            InkResponse(
              radius: 16,
              onTap: _onTapClose,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SvgPicture.asset(
                  'assets/images/vector_ic_close_tag_address.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonAddMore(String _text, GestureTapCallback _onTap) {
    return DottedBorder(
      borderType: BorderType.RRect,
      padding: EdgeInsets.all(1),
      color: AppColor.gray500,
      radius: Radius.circular(4),
      child: Material(
        color: AppColor.propzyBlue_100,
        child: InkWell(
          onTap: _onTap,
          child: Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/images/vector_ic_add_plus_blue.svg'),
                Text(
                  _text,
                  style: TextStyle(
                    color: AppColor.systemBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
