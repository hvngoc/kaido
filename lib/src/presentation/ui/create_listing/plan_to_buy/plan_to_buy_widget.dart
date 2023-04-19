import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_district/choose_district_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_drop_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/plan_to_buy/bloc/plan_to_buy_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/plan_to_buy/bloc/plan_to_buy_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/plan_to_buy/bloc/plan_to_buy_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_choice.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_price.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/choose_type_buy_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/debounce_timer.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class PlanToBuyWidget extends StatefulWidget {
  final int listingId;

  const PlanToBuyWidget({Key? key, required this.listingId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LegalState();
}

class _LegalState extends State<PlanToBuyWidget> {
  final int ID_SURE = 1;

  final PlanToBuyBloc _bloc = PlanToBuyBloc();
  final CreateListingBloc _createListingBloc = CreateListingBloc();

  int? buyPlanOptionId = null;
  ChooserData? districtId = null;
  int? priceFrom = null;
  int? priceFromInit = null;
  int? priceTo = null;
  int? priceToInit = null;
  ChooserData? propertyTypeId = null;

  final TimerDebounce _timerDebounce = TimerDebounce(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadListPlanEvent());
    _createListingBloc.add(GetDraftListingDetailEvent(widget.listingId));
  }

  @override
  void dispose() {
    _timerDebounce.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: MultiBlocListener(
          listeners: [
            BlocListener<CreateListingBloc, BaseCreateListingState>(
              bloc: _createListingBloc,
              listener: (context, state) {
                if (state is GetDraftListingDetailSuccessState) {
                  final plan = _createListingBloc.draftListing?.buyPlan;
                  if (plan != null) {
                    buyPlanOptionId = plan.buyPlanOption?.id;
                    final district = plan.district;
                    if (district != null) {
                      districtId = ChooserData(district.districtId, district.districtName);
                    }
                    final type = plan.propertyType;
                    if (type != null) {
                      propertyTypeId = ChooserData(type.id, type.name);
                    }
                    priceFrom = plan.priceFrom?.toInt();
                    priceTo = plan.priceTo?.toInt();
                    setState((){});
                    _timerDebounce.run(() {
                      priceFromInit = priceFrom;
                      priceToInit = priceTo;
                      setState(() {});
                    });
                  }
                }
              },
            ),
            BlocListener<PlanToBuyBloc, BasePlanToBuyState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is PlanToBuyStateSuccess) {
                  if (state.navigateScreen) {
                    NavigationController.navigateThankYouPage(
                      context,
                      widget.listingId,
                      showRecommend: buyPlanOptionId == ID_SURE,
                      districtId: districtId,
                      priceTo: priceTo,
                      priceFrom: priceFrom,
                      propertyTypeId: propertyTypeId,
                    );
                  }
                }
              },
            )
          ],
          child: Scaffold(
            appBar: PropzyAppBar(
              title: 'Đăng tin bất động sản',
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Bạn có đang tìm mua bất động sản?',
                      style: TextStyle(
                        color: AppColor.secondaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Đăng tin bán và tìm bất động sản mua ngay trên Propzy thật nhanh và hiệu quả',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColor.secondaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        BlocBuilder<PlanToBuyBloc, BasePlanToBuyState>(builder: (context, state) {
                          if (state is PlanToBuyStateSuccess) {
                            return ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 10),
                              physics: ClampingScrollPhysics(),
                              itemBuilder: _renderItemChild,
                              itemCount: _bloc.listData?.length ?? 0,
                              separatorBuilder: (c, i) {
                                return SizedBox(height: 10);
                              },
                            );
                          }
                          return Center(
                            child: LoadingView(
                              width: 160,
                              height: 80,
                            ),
                          );
                        }),
                        SizedBox(height: 10),
                        _renderInputPrice(),
                      ],
                    ),
                  ),
                  PropzyHomeContinueButton(
                    isEnable: isValid(),
                    onClick: () {
                      if (buyPlanOptionId == ID_SURE && priceTo! < priceFrom!) {
                        Util.showMyDialog(
                          context: context,
                          message: 'Vui lòng nhập ‘giá đến’ phải lớn hơn ‘giá từ’',
                        );
                      } else {
                        _bloc.add(UpdatePlanToBuyEvent(
                          id: widget.listingId,
                          buyPlanOptionId: buyPlanOptionId,
                          districtId: districtId?.id,
                          priceTo: priceTo,
                          priceFrom: priceFrom,
                          propertyTypeId: propertyTypeId?.id,
                        ));
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _renderInputPrice() {
    if (buyPlanOptionId == ID_SURE) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            BoldSectionTitle(
              text: 'Loại hình BĐS bạn đang tìm kiếm?',
              paddingLeft: 0,
            ),
            SizedBox(height: 10),
            FieldTextDropNoTitle(
              title: propertyTypeId?.name,
              hint: 'Chọn loại hình BĐS',
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                final screen = ChoosePropertiesBuyScreen(lastChooser: propertyTypeId);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
                final data = result[BaseChooserScreen.PARAM] as ChooserData;
                setState(() {
                  this.propertyTypeId = data;
                });
              },
            ),
            SizedBox(height: 12),
            BoldSectionTitle(
              text: 'Bạn muốn mua BĐS ở đâu?',
              paddingLeft: 0,
            ),
            SizedBox(height: 10),
            FieldTextDropNoTitle(
              title: districtId?.name,
              hint: 'Chọn Quận/Huyện',
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                final screen = ChooseDistrictScreen(lastChooser: districtId);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
                final data = result[BaseChooserScreen.PARAM] as ChooserData;
                setState(() {
                  this.districtId = data;
                });
              },
            ),
            SizedBox(height: 12),
            BoldSectionTitle(
              text: 'Khoảng giá bạn muốn mua',
              paddingLeft: 0,
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: FieldTextPrice(
                    hint: 'Giá từ',
                    unit: 'VNĐ',
                    lastValue: priceFrom?.toString(),
                    initValue: priceFromInit?.toString(),
                    allowZero: false,
                    onChange: (e) {
                      priceFrom = e;
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                  child: Text(
                    "-",
                    style: TextStyle(
                      color: AppColor.secondaryText,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FieldTextPrice(
                    hint: 'Giá đến',
                    unit: 'VNĐ',
                    allowZero: false,
                    lastValue: priceTo?.toString(),
                    initValue: priceToInit?.toString(),
                    onChange: (e) {
                      priceTo = e;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _renderItemChild(context, position) {
    final item = _bloc.listData?[position];
    if (item == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FieldTextChoice(
        isChecked: buyPlanOptionId == item.id,
        title: item.name ?? '',
        onTap: () {
          buyPlanOptionId = item.id;
          if (buyPlanOptionId != ID_SURE) {
            districtId = null;
            propertyTypeId = null;
            priceFrom = null;
            priceTo = null;
          }
          setState(() {});
        },
      ),
    );
  }

  bool isValid() {
    if (buyPlanOptionId == null) {
      return false;
    }
    if (buyPlanOptionId == ID_SURE) {
      return districtId != null && priceFrom != null && priceTo != null && propertyTypeId != null;
    }
    return true;
  }
}
