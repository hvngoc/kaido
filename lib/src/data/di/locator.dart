import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/config/app_config.dart';
import 'package:propzy_home/src/data/local/db/app_database.dart';
import 'package:propzy_home/src/data/local/db/app_database_impl.dart';
import 'package:propzy_home/src/data/local/pref/app_pref.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/remote/api/app_service.dart';
import 'package:propzy_home/src/data/remote/api/ibuy_service.dart';
import 'package:propzy_home/src/data/remote/api/listing_service.dart';
import 'package:propzy_home/src/data/remote/api/search_service.dart';
import 'package:propzy_home/src/data/remote/api/upload_service.dart';
import 'package:propzy_home/src/data/remote/api/user_service.dart';
import 'package:propzy_home/src/data/remote/dio_builder.dart';

final locator = GetIt.instance..allowReassignment = true;

Future setupDataLocator() async {
  _registerApiServices();
  //_registerNetworkModules();
  _registerSharedPreferences();
}

void _registerApiServices() {
  locator.registerLazySingleton<UserService>(() => UserService(_dioBuilder()));
  locator
      .registerLazySingleton<SearchService>(() => SearchService(_dioBuilder()));
  locator.registerLazySingleton<IbuyService>(() => IbuyService(_dioBuilder()));
  locator.registerLazySingleton<ListingService>(
      () => ListingService(_dioBuilder()));
  locator.registerLazySingleton<AppService>(() => AppService(_dioBuilder()));
  locator.registerLazySingleton<UploadService>(() => UploadService(
      _dioBuilder(),
      baseUrl: locator<AppConfig>().uploadListingUrl));
  return;
  locator.registerLazySingleton<UserService>(
      () => UserService(locator.get<Dio>()));
  locator.registerLazySingleton<SearchService>(
      () => SearchService(locator.get<Dio>()));
  locator.registerLazySingleton<IbuyService>(
      () => IbuyService(locator.get<Dio>()));
  locator.registerLazySingleton<ListingService>(
      () => ListingService(locator.get<Dio>()));
  locator
      .registerLazySingleton<AppService>(() => AppService(locator.get<Dio>()));
  locator.registerLazySingleton<UploadService>(() => UploadService(
      locator.get<Dio>(),
      baseUrl: locator<AppConfig>().uploadListingUrl));
}

void _registerNetworkModules() {
  locator.registerLazySingleton<Dio>(
      () => DioBuilder.getInstance(locator<AppConfig>().baseUrl));
  locator.registerLazySingleton<Dio>(
      () => DioBuilder.getTrackingInstance(locator<AppConfig>().trackingUrl));
}

void _registerSharedPreferences() {
  locator.registerLazySingleton<PrefHelper>(() => AppPrefs());
  locator.registerLazySingleton<AppDatabase>(() => AppDatabaseImpl());
}

DioBuilder _dioBuilder({bool isBase = true}) {
  if (isBase) {
    return DioBuilder.getInstance(locator<AppConfig>().baseUrl);
  }
  return DioBuilder.getTrackingInstance(locator<AppConfig>().trackingUrl);
}
