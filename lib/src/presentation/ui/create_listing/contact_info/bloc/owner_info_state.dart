abstract class OwnerInfoState {}

class InitialOwnerInfoState extends OwnerInfoState {}

class LoadingState extends OwnerInfoState {}

class ErrorState extends OwnerInfoState {
  final String? message;

  ErrorState(this.message);
}

class SuccessUpdateOwnerInfoState extends OwnerInfoState {}