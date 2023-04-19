import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_price.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_8/bloc/Step8Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class HomeInformationStep8 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Step8State();
}

class _Step8State extends State<HomeInformationStep8> {
  final Step8Bloc bloc = GetIt.instance.get<Step8Bloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  int? expectedPriceFrom = null;
  int? expectedPriceFromInit = null;
  int? expectedPriceTo = null;
  int? expectedPriceToInit = null;

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
              if (_propzyHomeBloc.draftOffer?.id != null) {
                NavigationController.navigateToPropertyMedia(context, _propzyHomeBloc.draftOffer!.id!);
              }
            } else if (state is GetOfferDetailSuccess) {
              final offer = _propzyHomeBloc.draftOffer;
              if (offer == null) {
                return;
              }
              expectedPriceFrom = offer.expectedPriceFrom?.toInt();
              expectedPriceFromInit = offer.expectedPriceFrom?.toInt();
              expectedPriceTo = offer.expectedPriceTo?.toInt();
              expectedPriceToInit = offer.expectedPriceTo?.toInt();
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
                            'Mức giá bạn mong muốn bán',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColor.blackDefault,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Giúp Propzy thấu hiểu nhu cầu để tư vấn gói bán phù hợp nhất dành riêng cho bạn',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.propzyHomeDes,
                            ),
                          ),
                          SizedBox(height: 40),
                          FieldTextPrice(
                            titleHeader: 'Giá từ',
                            hint: 'Nhập giá từ',
                            unit: 'VNĐ',
                            initValue: expectedPriceFromInit?.toString(),
                            onChange: (e) {
                              expectedPriceFrom = e;
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 20),
                          FieldTextPrice(
                            titleHeader: 'Giá đến',
                            hint: 'Nhập giá đến',
                            unit: 'VNĐ',
                            initValue: expectedPriceToInit?.toString(),
                            onChange: (e) {
                              expectedPriceTo = e;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    PropzyHomeContinueButton(
                      isEnable: isSelected(),
                      height: 50,
                      onClick: () {
                        if (expectedPriceTo! < expectedPriceFrom!) {
                          Util.showMyDialog(
                            context: context,
                            message: 'Vui lòng nhập ‘giá đến’ phải lớn hơn ‘giá từ’',
                          );
                        } else {
                          final reachedPage = _propzyHomeBloc
                              .getReachedPageId(PropzyHomeScreenDirect.EXPECTED_PRICE.pageCode);
                          final event = UpdateOfferEvent(
                            reachedPageId: reachedPage,
                            expectedPriceFrom: expectedPriceFrom?.toDouble(),
                            expectedPriceTo: expectedPriceTo?.toDouble(),
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

  bool isSelected() {
    return expectedPriceFrom != null && expectedPriceTo != null;
  }
}
