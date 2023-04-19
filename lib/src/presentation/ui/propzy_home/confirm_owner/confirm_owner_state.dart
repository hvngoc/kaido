import 'package:propzy_home/src/domain/model/owner_type_model.dart';

abstract class ConfirmOwnerState {}

class InitialConfirmOwnerState extends ConfirmOwnerState {}
class ErrorConfirmOwnerState extends ConfirmOwnerState {
  final String? message;

  ErrorConfirmOwnerState(this.message);
}

class LoadingGetListOwnerTypeState extends ConfirmOwnerState {}

class SuccessGetListOwnerTypeState extends ConfirmOwnerState {
  final List<OwnerType>? listOwnerTypes;

  SuccessGetListOwnerTypeState(this.listOwnerTypes);
}

class SuccessSingleSignOnState extends ConfirmOwnerState {}

class ErrorSingleSignOnState extends ConfirmOwnerState {}

class LoadingCreateOfferState extends ConfirmOwnerState {}

class SuccessCreateOfferState extends ConfirmOwnerState {
  final int? offerId;

  SuccessCreateOfferState(this.offerId);
}