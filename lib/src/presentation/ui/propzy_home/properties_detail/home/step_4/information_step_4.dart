import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_drop_down.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_4/bloc/Step4Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class HomeInformationStep4 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Step4State();
}

class Step4State extends State<HomeInformationStep4> {
  final Step4Bloc bloc = GetIt.instance.get<Step4Bloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  String titleHeader = "Số lượng phòng trong căn nhà của bạn";
  String titleAction = "Tiếp tục";
  String titleBathroom = "Số phòng tắm";
  String titleKitchen = "Nhà bếp";
  String pageCode = PropzyHomeScreenDirect.NUMBER_OF_ROOMS.pageCode;

  int? bedroom = null;
  int? bathroom = null;
  int? livingRoom = null;
  int? kitchen = null;

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
              Log.w('update success step 44444');
              NavigationController.navigateToIBuyQAHomeStep5(context);
            } else if (state is GetOfferDetailSuccess) {
              final offer = _propzyHomeBloc.draftOffer;
              if (offer == null) {
                return;
              }
              bedroom = offer.bedroom;
              bathroom = offer.bathroom;
              livingRoom = offer.livingRoom;
              kitchen = offer.kitchen;
              setState(() {});
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                child: Column(
                  children: [
                    PropzyHomeHeaderView(isLoadOfferDetail: true),
                    if (_propzyHomeBloc.draftOffer?.id != null)
                      PropzyHomeProgressPage(
                        offerId: _propzyHomeBloc.draftOffer!.id!,
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(
                          bottom: 10,
                          left: 6,
                          right: 6,
                        ),
                        physics: ClampingScrollPhysics(),
                        children: [
                          Text(
                            titleHeader,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColor.blackDefault,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Cung cấp thông tin đầy đủ giúp bạn nhận giá đề nghị sơ bộ chính xác nhất.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.propzyHomeDes,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          FieldTextDropDown(
                            title: 'Số phòng ngủ',
                            value: bedroom?.toString() ?? '',
                            childWidth: 128,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: showPickerBedroom,
                              );
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                          FieldTextDropDown(
                            title: titleBathroom,
                            value: bathroom?.toString() ?? '',
                            childWidth: 128,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: showPickerBathroom,
                              );
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                          FieldTextDropDown(
                            title: 'Phòng khách',
                            value: livingRoom?.toString() ?? '',
                            childWidth: 128,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: showPickerLivingRoom,
                              );
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                          FieldTextDropDown(
                            title: titleKitchen,
                            value: kitchen?.toString() ?? '',
                            childWidth: 128,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: showPickerKitchen,
                              );
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                    PropzyHomeContinueButton(
                      isEnable: isSelected(),
                      height: 50,
                      content: titleAction,
                      onClick: () {
                        final reachedPage =
                            _propzyHomeBloc.getReachedPageId(pageCode);
                        final event = UpdateOfferEvent(
                          reachedPageId: reachedPage,
                          bedroom: bedroom,
                          bathroom: bathroom,
                          livingRoom: livingRoom,
                          kitchen: kitchen,
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
    return bedroom != null &&
        bathroom != null &&
        livingRoom != null &&
        kitchen != null;
  }

  Widget showPickerBedroom(BuildContext context) {
    return _showPickerDialog(context, 'Số phòng ngủ', bedroom, (e) {
      bedroom = e;
      setState(() {});
    });
  }

  Widget showPickerBathroom(BuildContext context) {
    return _showPickerDialog(context, titleBathroom, bathroom, (e) {
      bathroom = e;
      setState(() {});
    });
  }

  Widget showPickerLivingRoom(BuildContext context) {
    return _showPickerDialog(context, 'Phòng khách', livingRoom, (e) {
      livingRoom = e;
      setState(() {});
    });
  }

  Widget showPickerKitchen(BuildContext context) {
    return _showPickerDialog(context, titleKitchen, kitchen, (e) {
      kitchen = e;
      setState(() {});
    });
  }

  Widget _showPickerDialog(
    BuildContext context,
    String title,
    int? current,
    Function(int) callback,
  ) {
    List<Widget> view = bloc.numbers
        .map((e) => SortItemChildView(
            text: e.toString(),
            isChecked: e == current,
            onClick: () {
              callback(e);
              Navigator.pop(context);
            }))
        .toList();
    return Container(
      width: double.infinity,
      height: 110 + (view.length * 50),
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
              title,
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
