part of 'delete_account_bloc.dart';

@immutable
abstract class DeleteAccountState {}

enum DeleteAccountStatus {
  deleted,
  confirm,
  countDown,
}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoadingState extends DeleteAccountState {}

class DeleteAccountErrorState extends DeleteAccountState {
  final String errorMessage;
  DeleteAccountErrorState(
    this.errorMessage,
  );
}

class GetDeleteAccountInfoSuccessState extends DeleteAccountState {
  final DeleteAccountStatus deleteAccountStatus;
  final DeleteAccountInfo info;
  GetDeleteAccountInfoSuccessState(
    this.deleteAccountStatus,
    this.info,
  );
}

class SendDeleteSuccessState extends DeleteAccountState {}

class CancelDeleteSuccessState extends DeleteAccountState {}
