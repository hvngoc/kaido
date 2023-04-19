import 'dart:async';
import 'dart:io';

import 'package:flutter_appauth/flutter_appauth.dart';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/data/remote/api/user_service.dart';
import 'package:propzy_home/src/domain/repository/auth_repository.dart';
import 'package:propzy_home/src/util/constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String coreUrl;
  final String coreUrlFE;
  final UserService service;
  final PrefHelper prefHelper;

  AuthRepositoryImpl(String coreUrl, String coreUrlFE, UserService service, PrefHelper prefHelper)
      : this.coreUrl = coreUrl,
        this.coreUrlFE = coreUrlFE,
        this.service = service,
        this.prefHelper = prefHelper,
        IDENTITY_SERVICE_ISSUER = '${coreUrl}identity',
        IDENTITY_SERVICE_REGISTER = '${coreUrlFE}register',
        IDENTITY_SERVICE_LOGIN_SMS = '${coreUrlFE}login-sms',
        IDENTITY_SERVICE_TOKEN = '${coreUrl}identity/openid-connect/token';

  late String IDENTITY_SERVICE_ISSUER;
  late String IDENTITY_SERVICE_REGISTER;
  late String IDENTITY_SERVICE_LOGIN_SMS;
  late String IDENTITY_SERVICE_TOKEN;
  final APP_CLIENT_ID = 'flutter-app';
  final APP_REDIRECT_URI =
      Platform.isIOS ? 'vn.propzy.propzyapp://login-callback' : 'vn.propzy.sam:/login-callback';

  final FlutterAppAuth appAuth = FlutterAppAuth();

  // final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  // final _controller = StreamController<UserInfo?>();

  // void dispose() => _controller.close();

  UserInfo? userInfo;

  UserInfo? get currentUser => userInfo;

  // Stream<UserInfo?> get currentUser async* {
  //   yield* _controller.stream;
  // }

  Future<UserInfo?> singleSignOn(SSOActionType actionType) async {
    final loginRequest = AuthorizationTokenRequest(
      APP_CLIENT_ID,
      APP_REDIRECT_URI,
      issuer: IDENTITY_SERVICE_ISSUER,
      scopes: ['openid', 'profile', 'offline_access'],
      allowInsecureConnections: true,
      promptValues: ['login'],
    );

    final signUpRequest = AuthorizationTokenRequest(
      APP_CLIENT_ID,
      APP_REDIRECT_URI,
      issuer: IDENTITY_SERVICE_ISSUER,
      serviceConfiguration: AuthorizationServiceConfiguration(
        authorizationEndpoint: IDENTITY_SERVICE_REGISTER,
        tokenEndpoint: IDENTITY_SERVICE_TOKEN,
      ),
      scopes: ['openid', 'profile', 'offline_access'],
      allowInsecureConnections: true,
      promptValues: ['register'],
    );

    final loginSmsRequest = AuthorizationTokenRequest(
      APP_CLIENT_ID,
      APP_REDIRECT_URI,
      issuer: IDENTITY_SERVICE_ISSUER,
      serviceConfiguration: AuthorizationServiceConfiguration(
        authorizationEndpoint: IDENTITY_SERVICE_LOGIN_SMS,
        tokenEndpoint: IDENTITY_SERVICE_TOKEN,
      ),
      scopes: ['openid', 'profile', 'offline_access'],
      allowInsecureConnections: true,
      promptValues: ['login-sms'],
    );

    try {
      AuthorizationTokenRequest? request;
      if (actionType == SSOActionType.login) {
        request = loginRequest;
      } else if (actionType == SSOActionType.loginSMS) {
        request = loginSmsRequest;
      } else if (actionType == SSOActionType.signUp) {
        request = signUpRequest;
      }
      if (request == null) {
        return null;
      }
      final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(request);

      final refreshToken = result?.refreshToken ?? null;
      if (refreshToken != null) {
        await prefHelper.setRefreshToken(refreshToken);
      }

      final accessToken = result?.accessToken ?? null;
      if (accessToken != null) {
        await prefHelper.setAccessToken(accessToken);
        BaseResponse<UserInfo> response = await service.getProfile(accessToken);
        if (response.code == "200") {
          final user = response.data;
          // _controller.add(user);
          this.userInfo = user;
        }
      }
      await prefHelper.setUserInfo(userInfo);
      return userInfo;
    } catch (e, s) {
      print('login error: $e - stack: $s');
      return null;
    }
  }

  Future<bool> reloadAccessToken() async {
    final storedRefreshToken = await prefHelper.getRefreshToken();
    // print('TTT refreshToken ${storedRefreshToken}');
    if (storedRefreshToken == null) {
      print('Null storedRefreshToken');
      await signOut();
      return false;
    }
    try {
      final response = await appAuth.token(
        TokenRequest(
          APP_CLIENT_ID,
          APP_REDIRECT_URI,
          issuer: IDENTITY_SERVICE_ISSUER,
          refreshToken: storedRefreshToken,
        ),
      );

      final refreshToken = response?.refreshToken ?? null;
      if (refreshToken != null) {
        await prefHelper.setRefreshToken(refreshToken);
      } else {
        print('error get refreshToken');
        await signOut();
        return false;
      }

      final accessToken = response?.accessToken ?? null;
      if (accessToken != null) {
        await prefHelper.setAccessToken(accessToken);
        BaseResponse<UserInfo> response = await service.getProfile(accessToken);
        if (response.code == "200") {
          final user = response.data;
          // _controller.add(user);
          this.userInfo = user;
        } else {
          print('error get profile: ${response.message ?? 'unknown'}');
          await signOut();
          return false;
        }
      } else {
        print('error get accessToken');
        await signOut();
        return false;
      }
      await prefHelper.setUserInfo(userInfo);
      return true;
    } catch (e, s) {
      print('error on refreshToken: $e - stack: $s');
      await signOut();
      return false;
    }
  }

  Future<void> signOut() async {
    await prefHelper.removeAccessToken();
    await prefHelper.removeRefreshToken();
    await prefHelper.removeUserInfo();
    this.userInfo = null;
  }
}
