import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_drop_down.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_6/bloc/Step6Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class HomeInformationStep6 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step6State();
}

class _Step6State extends State<HomeInformationStep6> {
  final Step6Bloc bloc = GetIt.instance.get<Step6Bloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  bool checkYearBuilt = false;
  int? numYearBuilt = null;

  bool checkNotKnow = false;

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
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            if (state is UpdateOfferSuccessState) {
              Log.d('update success 6');
              NavigationController.navigateToIBuyQAHomeStep7(context);
            } else if (state is GetOfferDetailSuccess) {
              final offer = _propzyHomeBloc.draftOffer;
              if (offer == null) {
                return;
              }
              numYearBuilt = offer.yearBuilt;
              checkNotKnow = numYearBuilt == 0;
              checkYearBuilt = numYearBuilt != null && numYearBuilt != 0;

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
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 10, left: 6, right: 6),
                        physics: ClampingScrollPhysics(),
                        children: [
                          Text(
                            'Năm xây dựng căn nhà của bạn',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColor.blackDefault,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Cung cấp thông tin đầy đủ giúp bạn nhận giá đề nghị sơ bộ chính xác nhất.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.propzyHomeDes,
                            ),
                          ),
                          SizedBox(height: 40),
                          InkWell(
                            onTap: () {
                              checkYearBuilt = !checkYearBuilt;
                              checkNotKnow = false;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                SvgPicture.asset(checkYearBuilt
                                    ? "assets/images/vector_ic_type_properties_checked.svg"
                                    : "assets/images/vector_ic_type_properties_normal.svg"),
                                SizedBox(width: 10),
                                Flexible(
                                  child: FieldTextDropDown(
                                    title: 'Năm xây dựng',
                                    childWidth: 128,
                                    value: numYearBuilt?.toString() ?? '',
                                    onTap: checkYearBuilt
                                        ? () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: showPickerYear,
                                            );
                                          }
                                        : null,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(color: AppColor.dividerGray, height: 1),
                          InkWell(
                            onTap: () {
                              checkNotKnow = !checkNotKnow;
                              checkYearBuilt = false;
                              numYearBuilt = null;
                              setState(() {});
                            },
                            child: Container(
                              height: 64,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  SvgPicture.asset(checkNotKnow
                                      ? "assets/images/vector_ic_type_properties_checked.svg"
                                      : "assets/images/vector_ic_type_properties_normal.svg"),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Không nhớ năm xây dựng',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColor.blackDefault,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 60),
                          Lottie.asset(
                            'assets/json/propzy_home_man_build_house.json',
                            width: 192,
                            height: 192,
                            repeat: true,
                            frameRate: FrameRate.max,
                          ),
                        ],
                      ),
                    ),
                    PropzyHomeContinueButton(
                      isEnable: isSelected(),
                      height: 50,
                      onClick: () {
                        final reachedPage = _propzyHomeBloc.getReachedPageId(
                            PropzyHomeScreenDirect.YEAR_BUILT.pageCode);
                        final event = UpdateOfferEvent(
                          reachedPageId: reachedPage,
                          yearBuilt: checkYearBuilt ? numYearBuilt : 0,
                        );
                        _propzyHomeBloc.add(event);
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
    return checkNotKnow || (checkYearBuilt && numYearBuilt != null);
  }

  Widget showPickerYear(BuildContext context) {
    List<Widget> view = bloc.listYear
        .map((e) => SortItemChildView(
            text: e.toString(),
            isChecked: e == numYearBuilt,
            onClick: () {
              numYearBuilt = e;
              setState(() {});
              Navigator.pop(context);
            }))
        .toList();
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 14,
          ),
          Container(
            height: 5,
            width: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                20,
              ),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Container(
            padding: EdgeInsets.all(
              16,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  12,
                ),
                topRight: Radius.circular(
                  12,
                ),
              ),
            ),
            child: Text(
              'Năm xây dựng',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.blackDefault,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                right: 20,
                left: 20,
                bottom: 20,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => view[index],
                itemCount: view.length,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                separatorBuilder: (c, i) {
                  return Divider(
                    color: AppColor.dividerGray,
                    height: 1,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
