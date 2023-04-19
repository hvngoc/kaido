part of 'detail_offer_bloc.dart';

abstract class DetailOfferEvent extends Equatable {
  const DetailOfferEvent();
}

class DetailOfferGetOfferEvent extends DetailOfferEvent {
  final int offerId;

  DetailOfferGetOfferEvent(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

class GetPropertyTypeEvent extends DetailOfferEvent {
  @override
  List<Object?> get props => [];
}
