import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/bloc/purchase_price_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/widgets/detail_info_card.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/widgets/map_info_card/map_info_card.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/widgets/price_info_card.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class PurchasePrice extends StatefulWidget {
  const PurchasePrice({
    Key? key,
    required this.offerId,
  }) : super(key: key);

  final int offerId;

  @override
  State<PurchasePrice> createState() => _PurchasePriceState();
}

class _PurchasePriceState extends State<PurchasePrice> {
  late PurchasePriceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PurchasePriceBloc();
    _bloc.add(GetOfferDetailEvent(widget.offerId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<PurchasePriceBloc, PurchasePriceState>(
            builder: (context, state) {
              if (state is PurchasePriceGetOfferSuccess &&
                  _bloc.offerModel != null) {
                final scheduleTime = _bloc.offerModel?.meeting?.scheduleTime;
                return Container(
                  color: HexColor('#F0F0F0'),
                  child: Column(
                    children: [
                      _renderHeader(),
                      Expanded(
                        child: ListView(
                          children: [
                            Column(
                              children: [
                                PriceInfoCard(
                                  offerId: widget.offerId,
                                  offerModel: _bloc.offerModel!,
                                ),
                                DetailInfoCard(offerModel: _bloc.offerModel!),
                                MapInfoCard(offerModel: _bloc.offerModel!),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: scheduleTime != null,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: OrangeButton(
                            title: 'Hoàn tất',
                            onPressed: () {
                              NavigationController.navigateToCompleteRequest(
                                  context, widget.offerId);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _renderHeader() {
    return Container(
      color: Colors.white,
      child: PropzyHomeHeaderView(
        onClickBack: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }
}
