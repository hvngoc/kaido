part of 'detail_offer_bloc.dart';

abstract class DetailOfferState extends Equatable {
  const DetailOfferState();
}

class DetailOfferInitial extends DetailOfferState {
  @override
  List<Object> get props => [];
}

class DetailOfferGetOfferFail extends DetailOfferState {
  @override
  List<Object> get props => [];
}

class DetailOfferGetOfferSuccess extends DetailOfferState {
  @override
  List<Object?> get props => [];
}

class SuccessGetPropertyTypeState extends DetailOfferState {
  final List<PropzyHomePropertyType>? propertyTypes;

  SuccessGetPropertyTypeState(this.propertyTypes);

  @override
  List<Object?> get props => [];
}

class ErrorGetPropertyTypeState extends DetailOfferState {
  final String? message;

  ErrorGetPropertyTypeState({this.message = null});

  @override
  List<Object?> get props => [];
}
