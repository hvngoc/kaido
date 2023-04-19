abstract class PropzyHomeState {}

class InitialPropzyHomeState extends PropzyHomeState {}

class LoadingState extends PropzyHomeState {}

class GetOfferDetailSuccess extends PropzyHomeState {}

class UpdateOfferSuccessState extends PropzyHomeState {}

class UpdateOfferErrorState extends PropzyHomeState {}

class LoadingCreateOfferState extends PropzyHomeState {}

class ErrorCreateOfferState extends PropzyHomeState {
  final String? message;

  ErrorCreateOfferState(this.message);
}

class SuccessCreateOfferState extends PropzyHomeState {
  final int? offerId;

  SuccessCreateOfferState(this.offerId);
}
