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
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_1/bloc/Apartment1Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_1/bloc/Apartment1Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_1/bloc/Apartment1State.dart';
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

class ApartmentStep1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Apartment1State();
}

class _Apartment1State extends State<ApartmentStep1> {
  final Apartment1Bloc bloc = GetIt.instance.get<Apartment1Bloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  String? modelCode = null;
  double? carpetArea = null;
  double? builtUpArea = null;
  int? floorOrdinalNumber = null;

  final TextEditingController modelCodeController = TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController builtUpAreaController = TextEditingController();
  final TextEditingController floorOrdinalNumberController =
      TextEditingController();

  HomeDirection? mainDoorDirectionId = null;
  HomeDirection? windowDirectionId = null;

  @override
  void initState() {
    super.initState();
    if (bloc.state is Apartment1Loading) {
      bloc.add(Apartment1Event());
    }
    _propzyHomeBloc.add(GetOfferDetailEvent());
  }

  @override
  void dispose() {
    super.dispose();
    modelCodeController.dispose();
    carpetAreaController.dispose();
    builtUpAreaController.dispose();
    floorOrdinalNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name =
        "${_propzyHomeBloc.draftOffer?.buildingName} - ${_propzyHomeBloc.draftOffer?.blockBuildingName}";
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
              Log.i('update apartment success 1');
              NavigationController.navigateToIBuyApartmentStep2(context);
            } else if (state is GetOfferDetailSuccess) {
              final offer = _propzyHomeBloc.draftOffer;
              if (offer == null) {
                return;
              }
              final door = offer.mainDoorDirection;
              if (door != null) {
                mainDoorDirectionId = HomeDirection(door.id, door.name);
              }
              final window = offer.windowDirection;
              if (window != null) {
                windowDirectionId = HomeDirection(window.id, window.name);
              }
              modelCode = offer.modelCode;
              modelCodeController.text = modelCode ?? '';
              carpetArea = offer.carpetArea;
              carpetAreaController.text =
                  carpetArea?.toString().displayVnd() ?? '';
              builtUpArea = offer.builtUpArea;
              builtUpAreaController.text =
                  builtUpArea?.toString().displayVnd() ?? '';
              floorOrdinalNumber = offer.floorOrdinalNumber?.toInt();
              floorOrdinalNumberController.text =
                  floorOrdinalNumber?.toString() ?? '';
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
                    SizedBox(height: 30),
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
                            'Diện tích & hướng của căn hộ',
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
                            height: 48,
                          ),
                          Row(
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColor.blackDefault,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          FieldTextInput(
                            title: 'Mã căn hộ',
                            childWidth: 128,
                            unit: '',
                            hint: null,
                            keyboardType: TextInputType.text,
                            textEditingController: modelCodeController,
                            onChanged: (value) {
                              modelCode = value;
                              setState(() {});
                            },
                          ),
                          Divider(color: AppColor.dividerGray, height: 1),
                          FieldTextInput(
                            title: 'Diện tích tim tường',
                            childWidth: 128,
                            unit: 'm²',
                            hint: null,
                            textEditingController: carpetAreaController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp('[-|\ ]'),
                              ),
                              DecimalInputFormatter(),
                            ],
                            onChanged: (value) {
                              carpetArea = value.parseVndDouble();
                              setState(() {});
                            },
                          ),
                          Divider(color: AppColor.dividerGray, height: 1),
                          FieldTextInput(
                            title: 'Diện tích thông thủy',
                            childWidth: 128,
                            unit: 'm²',
                            hint: null,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp('[-|\ ]'),
                              ),
                              DecimalInputFormatter(),
                            ],
                            textEditingController: builtUpAreaController,
                            onChanged: (value) {
                              builtUpArea = value.parseVndDouble();
                              setState(() {});
                            },
                          ),
                          Divider(color: AppColor.dividerGray, height: 1),
                          FieldTextInput(
                            title: 'Tầng thứ',
                            childWidth: 128,
                            unit: 'tầng',
                            hint: null,
                            textEditingController: floorOrdinalNumberController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-9]'),
                              ),
                              FilteringTextInputFormatter.deny(
                                RegExp(r'^0+'),
                              ),
                            ],
                            onChanged: (value) {
                              floorOrdinalNumber = int.tryParse(value);
                              setState(() {});
                            },
                          ),
                          Divider(color: AppColor.dividerGray, height: 1),
                          FieldTextDropDown(
                            title: 'Hướng cửa chính',
                            value: mainDoorDirectionId?.name,
                            childWidth: 128,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: showPickerDoor,
                              );
                            },
                          ),
                          Divider(color: AppColor.dividerGray, height: 1),
                          FieldTextDropDown(
                            title: 'Hướng cửa sổ',
                            value: windowDirectionId?.name,
                            childWidth: 128,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: showPickerWindow,
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
                            PropzyHomeScreenDirect.APARTMENT_SIZE.pageCode);
                        final event = UpdateOfferEvent(
                          reachedPageId: reachedPage,
                          modelCode: modelCode,
                          carpetArea: carpetArea,
                          builtUpArea: builtUpArea,
                          floorOrdinalNumber: floorOrdinalNumber,
                          mainDoorDirectionId: mainDoorDirectionId?.id,
                          windowDirectionId: windowDirectionId?.id,
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
    return modelCode != null &&
        Util.isDecimalNumber(carpetArea) &&
        Util.isDecimalNumber(builtUpArea) &&
        floorOrdinalNumber != null &&
        mainDoorDirectionId != null &&
        windowDirectionId != null;
  }

  Widget showPickerDoor(BuildContext context) {
    return _showPickerDialog(
        context, 'Hướng cửa chính', bloc.listDirections, mainDoorDirectionId,
        (e) {
      mainDoorDirectionId = e;
      Navigator.pop(context);
      setState(() {});
    });
  }

  Widget showPickerWindow(BuildContext context) {
    return _showPickerDialog(
        context, 'Hướng cửa sổ', bloc.listDirections, windowDirectionId, (e) {
      windowDirectionId = e;
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
