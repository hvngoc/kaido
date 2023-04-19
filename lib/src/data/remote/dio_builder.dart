import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:propzy_home/app.dart';
import 'package:propzy_home/src/data/interceptor/header_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:propzy_home/src/data/interceptor/tracking_header_interceptor.dart';

class DioBuilder extends DioMixin implements Dio {
  // create basic information for request
  final String contentType = 'application/json';
  final int connectionTimeOutMls = 30000;
  final int readTimeOutMls = 30000;
  final int writeTimeOutMls = 30000;

  factory DioBuilder.getInstance(String baseUrl) => DioBuilder._(baseUrl);
  factory DioBuilder.getTrackingInstance(String baseUrl) =>
      DioBuilder._tracking(baseUrl);

  DioBuilder._(String baseUrl) {
    options = BaseOptions(
      baseUrl: baseUrl,
      contentType: contentType,
      connectTimeout: connectionTimeOutMls,
      receiveTimeout: readTimeOutMls,
      sendTimeout: writeTimeOutMls,
    );

    interceptors.clear();

    // Add default user agent
    interceptors.add(HeaderInterceptor());

    // create default http client
    httpClientAdapter = DefaultHttpClientAdapter();

    if (!kReleaseMode) {
      interceptors.add(chuck.getDioInterceptor());
    }

    // Debug mode
    if (kDebugMode) {
      interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));

      interceptors.add(CurlLoggerDioInterceptor());
    }
  }

  // tracking Dio
  DioBuilder._tracking(String baseUrl) {
    options = BaseOptions(
      baseUrl: baseUrl,
      contentType: contentType,
      connectTimeout: connectionTimeOutMls,
      receiveTimeout: readTimeOutMls,
      sendTimeout: writeTimeOutMls,
    );

    interceptors.clear();
    // Add default user agent
    interceptors.add(TrackingHeaderInterceptor());

    // create default http client
    httpClientAdapter = DefaultHttpClientAdapter();

    if (!kReleaseMode) {
      interceptors.add(chuck.getDioInterceptor());
    }

    // Debug mode
    if (kDebugMode) {
      interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));

      interceptors.add(CurlLoggerDioInterceptor());
    }
  }
}
