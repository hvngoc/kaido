import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_contiguous.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/expand_single_custom_child.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_drop_down.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_input.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_2/bloc/Step2Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_2/bloc/Step2Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_2/bloc/Step2State.dart';
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

class HomeInformationStep2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step2State();
}

class _Step2State extends State<HomeInformationStep2> {
  final Step2Bloc bloc = GetIt.instance.get<Step2Bloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  late List<Widget> tab1;
  late List<Widget> tab2;

  bool chooseRoad = false;
  bool chooseAlley = false;

  double? roadWidth = null;
  TextEditingController roadWidthController = TextEditingController();
  HomeContiguous? roadContiguous = null;

  double? alleyWidth = null;
  double? distanceToRoad = null;
  HomeContiguous? alleyContiguous = null;
  TextEditingController alleyWidthController = TextEditingController();
  TextEditingController distanceToRoadController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    roadWidthController.dispose();
    alleyWidthController.dispose();
    distanceToRoadController.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (bloc.state is Step2Loading) {
      bloc.add(Step2Event());
    }
    _propzyHomeBloc.add(GetOfferDetailEvent());
    _initChildrenView();
  }

  void _resetData({
    bool chooseRoad = false,
    bool chooseAlley = false,
    double? roadWidth = null,
    HomeContiguous? roadContiguous = null,
    double? alleyWidth = null,
    double? distanceToRoad = null,
    HomeContiguous? alleyContiguous = null,
  }) {
    this.chooseRoad = chooseRoad;
    this.chooseAlley = chooseAlley;
    this.roadWidth = roadWidth;
    this.roadContiguous = roadContiguous;
    this.alleyWidth = alleyWidth;
    this.distanceToRoad = distanceToRoad;
    this.alleyContiguous = alleyContiguous;
    roadWidthController.text = roadWidth?.toString().displayVnd() ?? '';
    alleyWidthController.text = alleyWidth?.toString().displayVnd() ?? '';
    distanceToRoadController.text =
        distanceToRoad?.toString().displayVnd() ?? '';
  }

  void _initChildrenView() {
    tab1 = [
      FieldTextInput(
        title: 'Độ rộng mặt tiền',
        childWidth: 150,
        unit: 'm',
        hint: null,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp('[-|\ ]'),
          ),
          DecimalInputFormatter(),
        ],
        textEditingController: roadWidthController,
        onChanged: (value) {
          roadWidth = value.parseVndDouble();
          setState(() {});
        },
      ),
      FieldTextDropDown(
        title: 'Tiếp giáp',
        childWidth: 150,
        value: roadContiguous?.name,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          showModalBottomSheet(
            context: context,
            builder: showPickerRoadDialog,
            backgroundColor: Colors.transparent,
          );
        },
      )
    ];
    tab2 = [
      FieldTextInput(
        title: 'Độ rộng hẻm nhỏ nhất',
        childWidth: 128,
        unit: 'm',
        textEditingController: alleyWidthController,
        hint: null,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp('[-|\ ]'),
          ),
          DecimalInputFormatter(),
        ],
        onChanged: (value) {
          alleyWidth = value.parseVndDouble();
          setState(() {});
        },
      ),
      FieldTextInput(
        title: 'Khoảng cách tới đường chính',
        childWidth: 128,
        unit: 'm',
        textEditingController: distanceToRoadController,
        hint: null,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp('[-|\ ]'),
          ),
          DecimalInputFormatter(),
        ],
        onChanged: (value) {
          distanceToRoad = value.parseVndDouble();
          setState(() {});
        },
      ),
      FieldTextDropDown(
        title: 'Tiếp giáp',
        childWidth: 128,
        value: alleyContiguous?.name,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          showModalBottomSheet(
            context: context,
            builder: showPickerAlleyDialog,
            backgroundColor: Colors.transparent,
          );
        },
      )
    ];
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
              Log.w('update success step 2');
              NavigationController.navigateToIBuyQAHomeStep3(context);
            } else if (state is GetOfferDetailSuccess) {
              final offer = _propzyHomeBloc.draftOffer;
              if (offer == null) {
                return;
              }
              _resetData(
                chooseRoad:
                    offer.facadeType == Constants.FACADE_TYPE_ID_FOR_FACADE,
                chooseAlley:
                    offer.facadeType == Constants.FACADE_TYPE_ID_FOR_ALLEY,
                roadWidth: offer.facadeRoad?.roadWidth,
                roadContiguous: offer.facadeRoad == null
                    ? null
                    : HomeContiguous(offer.facadeRoad?.contiguous?.id,
                        offer.facadeRoad?.contiguous?.name),
                alleyWidth: offer.facadeAlley?.alleyWidth,
                distanceToRoad: offer.facadeAlley?.distanceToRoad,
                alleyContiguous: offer.facadeAlley == null
                    ? null
                    : HomeContiguous(offer.facadeAlley?.contiguous?.id,
                        offer.facadeAlley?.contiguous?.name),
              );
              _initChildrenView();
              setState(() {});
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    PropzyHomeHeaderView(isLoadOfferDetail: true),
                    if (_propzyHomeBloc.draftOffer?.id != null)
                      PropzyHomeProgressPage(
                        offerId: _propzyHomeBloc.draftOffer!.id!,
                      ),
                    SizedBox(height: 30),
                    Text(
                      'Vị trí căn nhà của bạn',
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
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.only(bottom: 10),
                        physics: ClampingScrollPhysics(),
                        itemBuilder: _renderItemChild,
                        itemCount: 2,
                        separatorBuilder: (c, i) {
                          return SizedBox(height: 8);
                        },
                      ),
                    ),
                    PropzyHomeContinueButton(
                      isEnable: isSelected(),
                      height: 50,
                      onClick: () {
                        final reachedPage = _propzyHomeBloc.getReachedPageId(
                            PropzyHomeScreenDirect.HOUSE_POSITION.pageCode);
                        if (chooseRoad) {
                          final event = UpdateFacadeEvent(
                            roadWidth: roadWidth,
                            id: roadContiguous?.id,
                            reachedPageId: reachedPage,
                          );
                          _propzyHomeBloc.add(event);
                        } else if (chooseAlley) {
                          final event = UpdateAlleyEvent(
                            reachedPageId: reachedPage,
                            alleyWidth: alleyWidth,
                            id: alleyContiguous?.id,
                            distanceToRoad: distanceToRoad,
                          );
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

  Widget _renderItemChild(context, position) {
    if (position == 0) {
      return ExpandSingleCustom(
        isChecked: chooseRoad,
        name: 'Mặt tiền',
        listCustom: tab1,
        onSectionTap: () {
          setState(() {
            final last = !chooseRoad;
            _resetData();
            _initChildrenView();
            chooseRoad = last;
          });
        },
      );
    } else if (position == 1) {
      return ExpandSingleCustom(
        isChecked: chooseAlley,
        name: 'Trong hẻm',
        listCustom: tab2,
        onSectionTap: () {
          setState(() {
            final last = !chooseAlley;
            _resetData();
            _initChildrenView();
            chooseAlley = last;
          });
        },
      );
    } else {
      return Container();
    }
  }

  bool isSelected() {
    if (chooseRoad &&
        Util.isDecimalNumber(roadWidth) &&
        roadContiguous != null) {
      return true;
    }
    if (chooseAlley &&
        Util.isDecimalNumber(alleyWidth) &&
        Util.isDecimalNumber(distanceToRoad) &&
        alleyContiguous != null) {
      return true;
    }
    return false;
  }

  Widget showPickerRoadDialog(BuildContext context) {
    return _showPickerDialog(context, bloc.listRoad, roadContiguous, (e) {
      roadContiguous = e;
      Navigator.pop(context);
      _initChildrenView();
      setState(() {});
    });
  }

  Widget showPickerAlleyDialog(BuildContext context) {
    return _showPickerDialog(context, bloc.listAlley, alleyContiguous, (e) {
      alleyContiguous = e;
      Navigator.pop(context);
      _initChildrenView();
      setState(() {});
    });
  }

  Widget _showPickerDialog(
    BuildContext context,
    List<HomeContiguous>? list,
    HomeContiguous? current,
    Function(HomeContiguous) callback,
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
              'Tiếp giáp',
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
