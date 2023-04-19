part of 'authentication_bloc.dart';

enum AuthenticationStatus { unknown, loading, authenticated, unauthenticated }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = null,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.loading() : this._(status: AuthenticationStatus.loading);

  const AuthenticationState.authenticated(UserInfo user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final UserInfo? user;

  @override
  List<Object?> get props => [status, user];
}

