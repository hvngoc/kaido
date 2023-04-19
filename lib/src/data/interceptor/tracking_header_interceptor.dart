import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_mac/get_mac.dart';
import 'package:propzy_home/src/config/app_config.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';

class TrackingHeaderInterceptor extends InterceptorsWrapper {
  final String _serviceIdHeader = 'service_id';
  final String _authorizationHeader = HttpHeaders.authorizationHeader;
  final String _fingerprintIdHeader = 'fingerprint_id';
  final String _bearer = 'Bearer';
  final locator = GetIt.I;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: implement onRequest
    //super.onRequest(options, handler);
    final _serviceId = locator<AppConfig>().trackingServiceId;
    options.headers[_serviceIdHeader] = _serviceId;

    final _macAddress = await GetMac.macAddress;
    if (_macAddress.isNotEmpty) {
      options.headers[_fingerprintIdHeader] = _macAddress;
    }

    final _token = await locator.get<PrefHelper>().getAccessToken() ?? '';
    if (_token.isNotEmpty) {
      options.headers[_authorizationHeader] = '$_bearer $_token';
    }

    handler.next(options);
  }
}
