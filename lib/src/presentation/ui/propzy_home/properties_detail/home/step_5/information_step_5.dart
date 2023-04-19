import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_choice.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_5/bloc/Step5Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class HomeInformationStep5 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step5State();
}

class _Step5State extends State<HomeInformationStep5> {
  final Step5Bloc bloc = GetIt.instance.get<Step5Bloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  bool checkFull = false;
  bool checkNormal = false;

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
              Log.d('update success 5555');
              NavigationController.navigateToIBuyQAHomeStep6(context);
            } else if (state is GetOfferDetailSuccess) {
              final offer = _propzyHomeBloc.draftOffer;
              if (offer == null) {
                return;
              }
              checkFull = offer.certificateLandId == 1;
              checkNormal = offer.certificateLandId == 2;
              setState((){});
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
                            'Giấy tờ pháp lý căn nhà của bạn',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColor.blackDefault,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Thông tin này giúp Propzy đưa ra tư vấn pháp lý hữu ích để bán nhà nhanh chóng và hiệu quả.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.propzyHomeDes,
                            ),
                          ),
                          SizedBox(height: 40),
                          FieldTextChoice(
                            isChecked: checkFull,
                            title: 'Đã có đầy đủ',
                            onTap: () {
                              checkFull = !checkFull;
                              checkNormal = false;
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 16),
                          FieldTextChoice(
                            isChecked: checkNormal,
                            title: 'Đang chờ/ đang bổ sung ',
                            onTap: () {
                              checkNormal = !checkNormal;
                              checkFull = false;
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 60),
                          Lottie.asset(
                            'assets/json/propzy_home_promo_code.json',
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
                        final reachedPage = _propzyHomeBloc
                            .getReachedPageId(PropzyHomeScreenDirect.CERTIFICATE_LAND.pageCode);
                        final event = UpdateOfferEvent(
                          reachedPageId: reachedPage,
                          certificateLandId: checkFull ? 1 : 2,
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
    return checkFull || checkNormal;
  }
}
