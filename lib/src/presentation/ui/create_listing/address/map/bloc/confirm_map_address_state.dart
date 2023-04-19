abstract class ConfirmMapAddressState {}

class InitialConfirmMapAddressState extends ConfirmMapAddressState {}

class LoadingState extends ConfirmMapAddressState {}

class ErrorState extends ConfirmMapAddressState {
  final String? message;

  ErrorState(this.message);
}

class SuccessUpdateMapState extends ConfirmMapAddressState {}