import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/domain/usecase/auth_use_case.dart';
import 'package:propzy_home/src/domain/usecase/get_profile_use_case.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:propzy_home/src/presentation/di/locator.dart';
import 'package:propzy_home/src/util/constants.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState.unknown()) {
    on<AuthenticationSignUpRequested>(_onSingleSignOnSignUp);
    on<AuthenticationLogInRequested>(_onSingleSignOn);
    on<AuthenticationLogoutRequested>(_onSignOutRequested);
    on<AuthenticationStatusChanged>(_onAuthenticationChanged);
    on<AuthenticationGetCurrentUser>(_onGetCurrentUser);

    // _authenticationSubscription = _getCurrentUserUseCase.currentUser.listen((user) {
    //   add(AuthenticationStatusChanged(user));
    // });
  }

  // final GetProfileUseCase _getProfileUseCase =
  //     GetIt.instance.get<GetProfileUseCase>();
  final SingleSignOnUseCase _singleSignOnUseCase =
      GetIt.instance.get<SingleSignOnUseCase>();
  final GetCurrentUserUseCase _getCurrentUserUseCase =
      GetIt.instance.get<GetCurrentUserUseCase>();
  final SignOutUseCase _signOutUseCase = GetIt.instance.get<SignOutUseCase>();

  // late StreamSubscription<UserInfo?> _authenticationSubscription;

  @override
  Future<void> close() {
    // _authenticationSubscription.cancel();
    // _getCurrentUserUseCase.dispose();
    return super.close();
  }

  void _onSingleSignOnSignUp(
      AuthenticationSignUpRequested event,
      Emitter<AuthenticationState> emitter,
      ) async {
    emitter(AuthenticationState.loading());
    final userInfo = await _singleSignOnUseCase.singleSignOn(SSOActionType.signUp);
    if (userInfo != null) {
      emitter(AuthenticationState.authenticated(userInfo));
    } else {
      emitter(AuthenticationState.unknown());
    }
  }

  void _onSingleSignOn(
    AuthenticationLogInRequested event,
    Emitter<AuthenticationState> emitter,
  ) async {
    emitter(AuthenticationState.loading());
    final userInfo = await _singleSignOnUseCase.singleSignOn(SSOActionType.login);
    if (userInfo != null) {
      emitter(AuthenticationState.authenticated(userInfo));
    } else {
      emitter(AuthenticationState.unknown());
    }
  }

  void _onSignOutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emitter,
  ) async {
    await _signOutUseCase.signOut();
    emitter(AuthenticationState.unauthenticated());
  }

  void _onAuthenticationChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emitter,
  ) {
    final user = event.user;
    if (user != null) {
      emitter(AuthenticationState.authenticated(user));
    }
  }

  void _onGetCurrentUser(
    AuthenticationGetCurrentUser event,
    Emitter<AuthenticationState> emitter,
  ) {
    final user = _getCurrentUserUseCase.currentUser;
    if (user != null) {
      emitter(AuthenticationState.authenticated(user));
    }
  }
}
