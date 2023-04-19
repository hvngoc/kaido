part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.user);

  final UserInfo? user;

  @override
  List<Object?> get props => [user];
}

class AuthenticationSignUpRequested extends AuthenticationEvent {}

class AuthenticationLogInRequested extends AuthenticationEvent {}

class AuthenticationLogoutRequested extends AuthenticationEvent {}

class AuthenticationGetCurrentUser extends AuthenticationEvent {}