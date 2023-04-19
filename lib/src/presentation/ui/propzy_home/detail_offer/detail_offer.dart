import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/detail_offer/bloc/detail_offer_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/detail_offer/widgets/collection_media_card.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/detail_offer/widgets/counselor_info_card.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/detail_offer/widgets/demand_info_card.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/detail_offer/widgets/status_of_offer_card.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/widgets/detail_info_card.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class DetailOffer extends StatefulWidget {
  const DetailOffer({
    Key? key,
    required this.offerId,
  }) : super(key: key);

  final int offerId;

  @override
  State<DetailOffer> createState() => _DetailOfferState();
}

class _DetailOfferState extends State<DetailOffer> {
  final DetailOfferBloc _bloc = DetailOfferBloc();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(GetPropertyTypeEvent());
    _bloc.add(DetailOfferGetOfferEvent(widget.offerId));
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider(create: (_) => _bloc);
    return BlocConsumer<DetailOfferBloc, DetailOfferState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is DetailOfferGetOfferSuccess || state is SuccessGetPropertyTypeState) {
          prepareData();
        }
      },
      builder: (context, state) {
        if (state is DetailOfferGetOfferSuccess && _bloc.offerModel != null) {
          final statusId = _bloc.offerModel?.status?.id ?? 0;
          return Scaffold(
            body: SafeArea(
              child: Container(
                child: Column(
                  children: [
                    _renderHeader(),
                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            children: [
                              StatusOfOfferCard(
                                  offerId: widget.offerId, offerModel: _bloc.offerModel!),
                              CounselorInfoCard(offerModel: _bloc.offerModel!),
                              DemandInfoCard(offerModel: _bloc.offerModel!),
                              DetailInfoCard(offerModel: _bloc.offerModel!),
                              CollectionMediaCard(offerModel: _bloc.offerModel!),
                              CollectionMediaCard(offerModel: _bloc.offerModel!, type: 2),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: statusId == 10,
                                      child: OrangeButton(title: 'Lựa chọn hấp dẫn khác'),
                                    ),
                                    Visibility(
                                      visible: statusId == 1 || statusId == 2,
                                      child: _renderCancelButton(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: SafeArea(
              child: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _renderCancelButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        color: Colors.transparent,
        child: Center(
          child: Text(
            'Huỷ đề nghị',
            style: TextStyle(
              color: AppColor.systemBlue,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderHeader() {
    return Container(
      color: Colors.white,
      child: PropzyHomeHeaderView(isLoadOfferDetail: true),
    );
  }

  void prepareData() {
    _propzyHomeBloc.add(SaveDraftOfferEvent(_bloc.offerModel));
    if (_bloc.propertyTypes != null && _bloc.offerModel?.propertyType != null) {
      for (int i = 0; i < _bloc.propertyTypes!.length; i++) {
        PropzyHomePropertyType propertyType = _bloc.propertyTypes![i];
        if (propertyType.id == _bloc.offerModel?.propertyType!.id) {
          _propzyHomeBloc.add(SavePropertyTypeSelectedEvent(propertyType));
          break;
        }
      }
    }
  }
}
