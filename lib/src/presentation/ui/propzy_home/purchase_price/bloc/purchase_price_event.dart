part of 'purchase_price_bloc.dart';

abstract class PurchasePriceEvent extends Equatable {
  const PurchasePriceEvent();
}

class GetOfferDetailEvent extends PurchasePriceEvent {
  final int offerId;

  GetOfferDetailEvent(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

class CallScheduleOfferEvent extends PurchasePriceEvent {
  final HomeScheduleOfferModel request;

  CallScheduleOfferEvent(this.request);

  @override
  List<Object?> get props => [request];
}
