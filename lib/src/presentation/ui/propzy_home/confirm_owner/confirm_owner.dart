import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/domain/model/owner_type_model.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/confirm_owner/confirm_owner_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/confirm_owner/confirm_owner_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/confirm_owner/confirm_owner_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class ConfirmOwnerScreen extends StatefulWidget {
  const ConfirmOwnerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConfirmOwnerScreenState();
}

class _ConfirmOwnerScreenState extends State<ConfirmOwnerScreen> {
  final ConfirmOwnerBloc _bloc = GetIt.instance.get<ConfirmOwnerBloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();
  final PrefHelper prefHelper = GetIt.instance.get<PrefHelper>();

  String SCREEN_PAGE_CODE = PropzyHomeScreenDirect.OWNER_TYPE.pageCode;

  List<OwnerType>? listOwnerTypes = null;
  UserInfo? userInfo = null;
  bool _isEnableButtonContinue = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    userInfo = await prefHelper.getUserInfo();
    _bloc.add(GetListOwnerTypeEvent());

    if (_propzyHomeBloc.draftOffer?.id != null) {
      _propzyHomeBloc.add(GetOfferDetailEvent());
    }
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
              navigateToIBuyContactInfo();
            } else if (state is GetOfferDetailSuccess) {
              prepareDataOwnerType();
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<ConfirmOwnerBloc, ConfirmOwnerState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is ErrorConfirmOwnerState) {
                Util.showMyDialog(
                  context: context,
                  message: state.message ?? MessageUtil.errorMessageDefault,
                );
              }
              if (state is SuccessGetListOwnerTypeState) {
                listOwnerTypes = state.listOwnerTypes;
                prepareDataOwnerType();
              }
              if (state is SuccessSingleSignOnState) {
                updateOffer();
              }
            },
            builder: (context, state) {
              return Scaffold(
                body: SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          _renderHeaderView(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Lottie.asset(
                                    'assets/json/lottie_view_animation_growing_house_propzy_home.json',
                                    width: 192,
                                    height: 192,
                                    repeat: true,
                                    frameRate: FrameRate.max,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _renderTitle(),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  _renderSubTitle(),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _renderContent(state),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 65,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _renderFooter(),
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

  Widget _renderHeaderView() {
    return PropzyHomeHeaderView(isLoadOfferDetail: true);
  }

  Widget _renderTitle() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Text(
          _propzyHomeBloc.draftOffer?.address ?? "91 Nguyễn Hữu Cảnh...",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.blackDefault,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _renderSubTitle() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Column(
          children: [
            Text(
              "Bạn là chủ sở hữu hay đại diện cho căn nhà này?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.blackDefault,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Thông tin này giúp Propzy tư vấn chính xác về chương trình bán phù hợp dành cho bạn",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.propzyHomeDes,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderContent(ConfirmOwnerState state) {
    return (state is LoadingGetListOwnerTypeState)
        ? Container(
            child: Center(
              child: LoadingView(
                width: 160,
                height: 160,
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: _renderListOwnerType(),
          );
  }

  Widget _renderListOwnerType() {
    if ((listOwnerTypes?.length ?? 0) == 0) return Container();
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: _renderItemOwnerType,
      itemCount: listOwnerTypes?.length,
    );
  }

  Widget _renderItemOwnerType(BuildContext context, int index) {
    OwnerType ownerType = listOwnerTypes!.elementAt(index);

    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      height: 53,
      decoration: BoxDecoration(
        color: ownerType.isSelected == true ? HexColor("E8EFF6") : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: ownerType.isSelected == true
              ? HexColor("007AFF")
              : HexColor("CED4DA"),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          for (int i = 0; i < listOwnerTypes!.length; i++) {
            OwnerType ownerType = listOwnerTypes![i];
            ownerType.isSelected = i == index;
          }

          setState(() {
            listOwnerTypes = listOwnerTypes;
            _isEnableButtonContinue = true;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ownerType.isSelected == true
                  ? "assets/images/ic_radio_button_selected_property_type.svg"
                  : "assets/images/ic_radio_button_unselected_property_type.svg",
              width: 16,
              height: 16,
            ),
            SizedBox(width: 8),
            Text(
              ownerType.name ?? "",
              style: TextStyle(
                color: AppColor.blackDefault,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderFooter() {
    return PropzyHomeContinueButton(
      isEnable: _isEnableButtonContinue,
      onClick: () async {
        String? accessToken = await prefHelper.getAccessToken();
        if (accessToken?.isNotEmpty == true) {
          updateOffer();
        } else {
          _bloc.add(SingleSignOnRequestEvent());
        }
      },
    );
  }

  void updateOffer() {
    // update offer
    int? reachedPage = _propzyHomeBloc.getReachedPageId(SCREEN_PAGE_CODE);
    final event = UpdateOfferEvent(
      reachedPageId: reachedPage,
      ownerTypeId: listOwnerTypes
          ?.firstWhere((element) => element.isSelected == true)
          .id,
    );
    _propzyHomeBloc.add(event);
  }

  void navigateToIBuyContactInfo() async {
    Util.hideLoading();
    NavigationController.navigateToIBuyContactInfo(context);
  }

  void prepareDataOwnerType() {
    if (_propzyHomeBloc.draftOffer?.ownerType?.id != null) {
      listOwnerTypes?.forEach((element) {
        element.isSelected =
            element.id == _propzyHomeBloc.draftOffer?.ownerType?.id;
      });
      setState(() {
        _isEnableButtonContinue = true;
      });
    } else {
      setState(() {
        _isEnableButtonContinue = false;
      });
    }
    setState(() {
      listOwnerTypes = listOwnerTypes;
    });
  }
}
