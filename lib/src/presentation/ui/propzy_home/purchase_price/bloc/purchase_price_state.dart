part of 'purchase_price_bloc.dart';

abstract class PurchasePriceState extends Equatable {
  const PurchasePriceState();
}

class PurchasePriceLoading extends PurchasePriceState {
  @override
  List<Object> get props => [];
}

class PurchasePriceGetOfferSuccess extends PurchasePriceState {
  PurchasePriceGetOfferSuccess();

  @override
  List<Object?> get props => [];
}