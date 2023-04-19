import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:propzy_home/src/data/local/pref/app_pref.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/force_update_info.dart';
import 'package:propzy_home/src/domain/usecase/auth_use_case.dart';
import 'package:propzy_home/src/domain/usecase/check_update_version_use_case.dart';
import 'package:propzy_home/src/domain/usecase/update_address_use_case.dart';
import 'package:propzy_home/src/presentation/ui/home/home_event.dart';
import 'package:propzy_home/src/presentation/ui/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialHomeState());
  final CheckUpdateVersionUseCase checkUpdateVersionUseCase =
      GetIt.instance.get<CheckUpdateVersionUseCase>();
  final ReloadAccessTokenUseCase reloadAccessTokenUseCase =
      GetIt.instance.get<ReloadAccessTokenUseCase>();
  final PrefHelper prefHelper = GetIt.instance.get<PrefHelper>();

  final UpdateDistrictUseCase updateDistrictUseCase = GetIt.instance.get<UpdateDistrictUseCase>();
  final UpdateWardUseCase updateWardUseCase = GetIt.instance.get<UpdateWardUseCase>();
  final UpdateStreetUseCase updateStreetUseCase = GetIt.instance.get<UpdateStreetUseCase>();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is CheckUpdateVersionEvent) {
      yield* checkUpdateVersionApp();
    } else if (event is ReloadAccessTokenEvent) {
      //await reloadAccessTokenUseCase.reloadAccessToken();
      yield* loadToken();
    } else if (event is GoToSearchEvent) {
      yield* prepareSearch(event);
    }
  }

  Stream<HomeState> prepareSearch(GoToSearchEvent event) async* {
    yield GoToSearchSuccess(event: event);
  }

  Stream<HomeState> loadToken() async* {
    bool isHasToken = await reloadAccessTokenUseCase.reloadAccessToken();
    if (isHasToken) {
      yield GetInfoStateSuccess();
    } else {
      yield GetInfoStateError();
    }
  }

  Stream<HomeState> checkUpdateVersionApp() async* {
    try {
      BaseResponse response = await checkUpdateVersionUseCase.checkUpdateVersion();
      ForceUpdateInfo? forceUpdateInfo = response.forceUpdateInfo;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String buildNumber = packageInfo.buildNumber;
      int code = forceUpdateInfo?.versionCode ?? int.parse(buildNumber);
      int versionCode = int.parse(buildNumber);

      // bool isAndroid = (forceUpdateInfo?.osName?.toLowerCase().contains("android") ?? false) &&
      //     Platform.isAndroid;
      // bool isIOS =
      //     (forceUpdateInfo?.osName?.toLowerCase().contains("ios") ?? false) && Platform.isIOS;
      if (code > versionCode) {
        // if (isAndroid) {
        //   yield ShowDialogForceUpdateState(forceUpdateInfo);
        // } else if (isIOS) {
        yield ShowDialogForceUpdateState(forceUpdateInfo);
        // }
      }
      final countryCache = forceUpdateInfo?.countryCacheUnit ?? -1;
      final lastCached = await prefHelper.getInt(AppPrefs.countryCacheUnit) ?? -1;
      if (countryCache > lastCached) {
        await prefHelper.setInt(AppPrefs.countryCacheUnit, countryCache);
        updateDistrict(true);
        updateWard(true);
        updateStreet(true);
      } else {
        updateDistrict(false);
        updateWard(false);
        updateStreet(false);
      }
    } catch (ex) {
      yield ErrorCheckUpdateVersionState(ex.toString());
    }
  }

  void updateDistrict(bool force) async {
    updateDistrictUseCase.update(force);
  }

  void updateWard(bool force) async {
    updateWardUseCase.update(force);
  }

  void updateStreet(bool force) async {
    updateStreetUseCase.update(force);
  }
}
