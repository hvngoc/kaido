import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';

class HeaderInterceptor extends InterceptorsWrapper {
  final String userAgentKey = HttpHeaders.userAgentHeader;
  final String authHeaderKey = HttpHeaders.authorizationHeader;
  final String bearer = 'Bearer';
  //final String? token = "6712f44d229c35298f31a22b857c83e0613294e2b748f7b24ee50961c81bfdc7";

  final locator = GetIt.instance;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final userAgentValue = await userAgentClientHintsHeader();

    String token = await locator.get<PrefHelper>().getAccessToken() ?? '';
    if (token.isNotEmpty == true) {
      options.headers[authHeaderKey] = '$bearer $token';
      // Map<String, String> map = {"access_token": token};
      // options.queryParameters.addAll(map);
    }
    options.headers[userAgentKey] = userAgentValue;

    handler.next(options);
  }

  Future<String> userAgentClientHintsHeader() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${Platform.operatingSystem} - ${packageInfo.buildNumber}';
    } on Exception catch (_) {
      return 'The Platform not support get info';
    }
  }
}
