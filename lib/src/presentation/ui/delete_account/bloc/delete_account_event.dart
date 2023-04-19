part of 'delete_account_bloc.dart';

@immutable
abstract class DeleteAccountEvent {}

class GetDeleteAccountInfoEvent extends DeleteAccountEvent {}

class RequestDeleteAccountEvent extends DeleteAccountEvent {
  final String password;
  final String reason;

  RequestDeleteAccountEvent({
    required this.password,
    required this.reason,
  });
}

class CancelDeleteAccountEvent extends DeleteAccountEvent {}
