import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_drop_down.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_input.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_3/bloc/Step3Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_3/bloc/Step3Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_3/bloc/Step3State.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/decimal_input_formatter.dart';
import 'package:propzy_home/src/util/extensions.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class HomeInformationStep3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step3State();
}

class _Step3State extends State<HomeInformationStep3> {
  final Step3Bloc bloc = GetIt.instance.get<Step3Bloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  double? length = null;
  double? width = null;
  double? lotSize = null;
  double? floorSize = null;
  int? numberFloor = null;
  HomeDirection? directionId = null;
  HomeDirection? houseShapeId = null;

  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController lotSizeController = TextEditingController();
  final TextEditingController floorSizeController = TextEditingController();
  final TextEditingController numberFloorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (bloc.state is Step3Loading) {
      bloc.add(Step3Event());
    }
    _propzyHomeBloc.add(GetOfferDetailEvent());
  }

  @override
  void dispose() {
    super.dispose();
    lengthController.dispose();
    widthController.dispose();
    lotSizeController.dispose();
    floorSizeController.dispose();
    numberFloorController.dispose();
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
              Log.w('update success step 333');
              NavigationController.navigateToIBuyQAHomeStep4(context);
            } else if (state is GetOfferDetailSuccess) {
              final offer = _propzyHomeBloc.draftOffer;
              if (offer == null) {
                return;
              }
              length = offer.length;
              width = offer.width;
              lotSize = offer.lotSize;
              floorSize = offer.floorSize;
              numberFloor = offer.numberFloor?.toInt();

              lengthController.text = length?.toString().displayVnd() ?? '';
              widthController.text = width?.toString().displayVnd() ?? '';
              lotSizeController.text = lotSize?.toString().displayVnd() ?? '';
              floorSizeController.text =
                  floorSize?.toString().displayVnd() ?? '';
              numberFloorController.text = numberFloor?.toString() ?? '';

              final direction = offer.direction;
              if (direction != null) {
                directionId = HomeDirection(direction.id, direction.name);
              }
              final house = offer.houseShape;
              if (house != null) {
                houseShapeId = HomeDirection(house.id, house.name);
              }
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
                            'Diện tích & hướng căn nhà của bạn',
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
                          FieldTextInput(
                            title: 'Chiều dài',
                            childWidth: 128,
                            unit: 'm',
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp('[-|\ ]'),
                              ),
                              DecimalInputFormatter(),
                            ],
                            textEditingController: lengthController,
                            hint: null,
                            onChanged: (value) {
                              length = value.parseVndDouble();
                              setState(() {});
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                          FieldTextInput(
                            title: 'Chiều rộng',
                            childWidth: 128,
                            unit: 'm',
                            hint: null,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp('[-|\ ]'),
                              ),
                              DecimalInputFormatter(),
                            ],
                            textEditingController: widthController,
                            onChanged: (value) {
                              width = value.parseVndDouble();
                              setState(() {});
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                          FieldTextInput(
                            title: 'Diện tích đất',
                            childWidth: 128,
                            unit: 'm²',
                            hint: null,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp('[-|\ ]'),
                              ),
                              DecimalInputFormatter(),
                            ],
                            textEditingController: lotSizeController,
                            onChanged: (value) {
                              lotSize = value.parseVndDouble();
                              setState(() {});
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                          FieldTextInput(
                            title: 'Diện tích sử dụng',
                            childWidth: 128,
                            unit: 'm²',
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp('[-|\ ]'),
                              ),
                              DecimalInputFormatter(),
                            ],
                            hint: null,
                            textEditingController: floorSizeController,
                            onChanged: (value) {
                              floorSize = value.parseVndDouble();
                              setState(() {});
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                          FieldTextInput(
                            title: 'Số tầng',
                            childWidth: 128,
                            unit: 'tầng',
                            hint: null,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-9]'),
                              )
                            ],
                            textEditingController: numberFloorController,
                            onChanged: (value) {
                              numberFloor = int.tryParse(value);
                              setState(() {});
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                          FieldTextDropDown(
                            title: 'Hướng',
                            value: directionId?.name,
                            childWidth: 128,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: showPickerDirection,
                              );
                            },
                          ),
                          Divider(
                            color: AppColor.dividerGray,
                            height: 1,
                          ),
                          FieldTextDropDown(
                            title: 'Hình dạng căn nhà',
                            value: houseShapeId?.name,
                            childWidth: 128,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: showPickerShapeDialog,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    PropzyHomeContinueButton(
                      isEnable: isSelected(),
                      height: 50,
                      onClick: () {
                        final reachedPage = _propzyHomeBloc.getReachedPageId(
                            PropzyHomeScreenDirect.HOUSE_SIZE.pageCode);
                        final event = UpdateOfferEvent(
                          reachedPageId: reachedPage,
                          length: length,
                          width: width,
                          lotSize: lotSize,
                          floorSize: floorSize,
                          numberFloor: numberFloor,
                          directionId: directionId?.id,
                          houseShapeId: houseShapeId?.id,
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
    return Util.isDecimalNumber(length) &&
        Util.isDecimalNumber(width) &&
        Util.isDecimalNumber(lotSize) &&
        Util.isDecimalNumber(floorSize) &&
        numberFloor != null &&
        directionId != null &&
        houseShapeId != null;
  }

  Widget showPickerDirection(BuildContext context) {
    return _showPickerDialog(context, 'Hướng', bloc.listDirection, directionId,
        (e) {
      directionId = e;
      Navigator.pop(context);
      setState(() {});
    });
  }

  Widget showPickerShapeDialog(BuildContext context) {
    return _showPickerDialog(
        context, 'Hình dạng căn nhà', bloc.listShape, houseShapeId, (e) {
      houseShapeId = e;
      Navigator.pop(context);
      setState(() {});
    });
  }

  Widget _showPickerDialog(
    BuildContext context,
    String title,
    List<HomeDirection>? list,
    HomeDirection? current,
    Function(HomeDirection) callback,
  ) {
    if (list == null) {
      return Container();
    }
    List<Widget> view = list
        .map((e) => SortItemChildView(
            text: e.name ?? '',
            isChecked: e.id == current?.id,
            onClick: () {
              callback(e);
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
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                title,
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
          ],
        ),
      ),
    );
  }
}
