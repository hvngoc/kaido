import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_choice.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_9/bloc/Step9Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_9/bloc/Step9Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_9/bloc/Step9State.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class HomeInformationStep9 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step9State();
}

class _Step9State extends State<HomeInformationStep9> {
  final Step9Bloc bloc = GetIt.instance.get<Step9Bloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  HomeDirection? currentChoice = null;

  @override
  void initState() {
    super.initState();
    if (bloc.state is Step9Loading) {
      bloc.add(Step9Event());
    }
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
              if (currentChoice?.id == 1) {
                NavigationController.navigateToIBuyQAHomeStep10(context);
              } else {
                NavigationController.navigateToLoadingProcessRequest(
                  context,
                  _propzyHomeBloc.draftOffer?.id ?? 0,
                );
              }
            } else if (state is GetOfferDetailSuccess) {
              final offer = _propzyHomeBloc.draftOffer;
              if (offer == null) {
                return;
              }
              final plan = offer.planning?.planningToBuy;
              if (plan != null) {
                currentChoice = HomeDirection(plan, '');
                setState(() {});
              }
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                child: Column(
                  children: [
                    PropzyHomeHeaderView(isLoadOfferDetail: true),
                    if (_propzyHomeBloc.draftOffer?.id != null)
                      PropzyHomeProgressPage(
                        offerId: _propzyHomeBloc.draftOffer!.id!,
                      ),
                    SizedBox(height: 30),
                    Text(
                      'Dự định mua nhà của bạn trong 1 năm tới',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColor.blackDefault,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Bạn sẽ là ưu tiên hàng đầu để Propzy giới thiệu các bất động sản tốt nhất',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.propzyHomeDes,
                      ),
                    ),
                    SizedBox(height: 40),
                    Expanded(
                      child: BlocBuilder<Step9Bloc, Step9State>(
                          builder: (context, state) {
                        if (state is Step9Success) {
                          return ListView.separated(
                            padding: EdgeInsets.only(bottom: 10),
                            physics: ClampingScrollPhysics(),
                            itemBuilder: _renderItemChild,
                            itemCount: bloc.listData?.length ?? 0,
                            separatorBuilder: (c, i) {
                              return SizedBox(height: 12);
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
                    ),
                    PropzyHomeContinueButton(
                      isEnable: isSelected(),
                      height: 50,
                      onClick: () {
                        final reachedPage = _propzyHomeBloc.getReachedPageId(
                            PropzyHomeScreenDirect.PLAN_TO_BUY.pageCode);
                        final event = UpdateOfferEvent(
                          reachedPageId: reachedPage,
                          planning: PropzyHomeOfferPlanning(
                              planningToBuy: currentChoice?.id),
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
    return currentChoice != null;
  }

  Widget _renderItemChild(context, position) {
    final item = bloc.listData?.elementAt(position);
    if (item == null) {
      return Container();
    }
    return FieldTextChoice(
      isChecked: currentChoice?.id == item.id,
      title: item.name ?? '',
      onTap: () {
        currentChoice = item;
        setState(() {});
      },
    );
  }
}
