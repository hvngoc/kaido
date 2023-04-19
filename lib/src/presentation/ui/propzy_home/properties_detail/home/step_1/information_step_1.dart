import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/expand_single_choice.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_1/bloc/Step1Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_1/bloc/Step1Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_1/bloc/Step1State.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class HomeInformationStep1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step1State();
}

class _Step1State extends State<HomeInformationStep1> {
  final Step1Bloc bloc = Step1Bloc();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(Step1Event());
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
              Log.w('update success 1');
              NavigationController.navigateToIBuyQAHomeStep2(context);
            } else if (state is GetOfferDetailSuccess) {
              _bindData();
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<Step1Bloc, Step1State>(
            bloc: bloc,
            listener: (context, state) {
              if (state is Step1Success) {
                _bindData();
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
                          'Kết cấu căn nhà của bạn',
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
                          child: BlocBuilder<Step1Bloc, Step1State>(builder: (context, state) {
                            if (state is Step1Success) {
                              return ListView.separated(
                                padding: EdgeInsets.only(bottom: 10),
                                physics: ClampingScrollPhysics(),
                                itemBuilder: _renderItemChild,
                                itemCount: bloc.listData?.length ?? 0,
                                separatorBuilder: (c, i) {
                                  return SizedBox(height: 8);
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
                          isEnable: bloc.isSelected(),
                          height: 50,
                          onClick: () {
                            final reachedPage = _propzyHomeBloc
                                .getReachedPageId(PropzyHomeScreenDirect.HOUSE_TEXTURE.pageCode);
                            final event = UpdateOfferEvent(
                              reachedPageId: reachedPage,
                              listHomeTextureIds: bloc.collectIds(),
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
          );
        },
      ),
    );
  }

  void _bindData() {
    final offer = _propzyHomeBloc.draftOffer?.houseTextures;
    final data = bloc.listData;
    if (offer == null || data == null) {
      return;
    }
    data.forEach((d) {
      d.isChecked = offer.any((e) => e.id == d.id);
    });
    setState(() {});
  }

  Widget _renderItemChild(context, position) {
    final item = bloc.listData?.elementAt(position);
    if (item == null) {
      return Container();
    }
    return ExpandSingleChoice(
      feature: item,
      onSectionTap: (option) {
        option.isChecked = !option.isChecked;
        bloc.clearOtherOption(option);
        setState(() {});
      },
      onChildTap: (option) {
        option.isChecked = !option.isChecked;
        setState(() {});
      },
    );
  }
}
