import 'dart:convert';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs extends PrefHelper {
  static const String countryCacheUnit = 'countryCacheUnit';
  static const String onBoardingStatus = 'onBoardingStatus';
  static const String firstTimeOpenApp = 'first_time_open_app';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userInfoKey = 'user_info_key';
  static const String listSearchHistoryRecentlyKey = 'list_revamp_search_history_recently';
  static const String lastSearchHistoryKey = 'last_search_history';
  static const String lastCategoryTypeKey = 'last_category_type';
  static const String guideMediaStatus = 'guide_media_status';
  static const String guideLegalStatus = 'guide_legal_status';

  @override
  Future<bool> firstRun() async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool(firstTimeOpenApp) ?? true;
  }

  @override
  Future<void> setFirstRun(bool isFirstRun) async {
    final _preferences = await SharedPreferences.getInstance();
    await _preferences.setBool(firstTimeOpenApp, isFirstRun);
  }

  @override
  Future<String?> getAccessToken() async {
    return getString(accessTokenKey);
  }

  @override
  Future<void> setAccessToken(String token) async {
    setString(accessTokenKey, token);
  }

  @override
  Future<bool> removeAccessToken() async {
    return removeData(accessTokenKey);
  }

  @override
  Future<UserInfo?> getUserInfo() async {
    String jsonString = await getString(userInfoKey) ?? "";
    if (jsonString.isNotEmpty) {
      try {
        UserInfo? userInfo = UserInfo.fromJson(json.decode(jsonString));
        return Future.value(userInfo);
      } catch (ex) {
        return Future.value(null);
      }
    } else {
      return Future.value(null);
    }
  }

  @override
  Future<void> setUserInfo(UserInfo? userInfo) {
    if (userInfo == null) {
      return setString(userInfoKey, "");
    } else {
      return setString(
        userInfoKey,
        json.encode(userInfo.toJson()),
      );
    }
  }

  @override
  Future<bool> removeUserInfo() {
    return removeData(userInfoKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return getString(refreshTokenKey);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    setString(refreshTokenKey, token);
  }

  @override
  Future<bool> removeRefreshToken() async {
    return removeData(refreshTokenKey);
  }

  @override
  Future<bool> setOnBoardingStatus(bool value) async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.setBool(onBoardingStatus, value);
  }

  @override
  Future<bool?> getOnBoardingStatus() async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool(onBoardingStatus);
  }

  @override
  Future<bool> setGuideMediaStatus(bool value) async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.setBool(guideMediaStatus, value);
  }

  @override
  Future<bool?> getGuideMediaStatus() async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool(guideMediaStatus);
  }

  @override
  Future<bool> setGuideLegalStatus(bool value) async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.setBool(guideLegalStatus, value);
  }

  @override
  Future<bool?> getGuideLegalStatus() async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool(guideLegalStatus);
  }

  @override
  Future<String?> getString(String key) async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.getString(key);
  }

  @override
  Future setString(String key, String value) async {
    final _preferences = await SharedPreferences.getInstance();
    await _preferences.setString(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.getInt(key);
  }

  @override
  Future setInt(String key, int value) async {
    final _preferences = await SharedPreferences.getInstance();
    await _preferences.setInt(key, value);
  }

  @override
  Future<bool> removeData(String key) async {
    final _preferences = await SharedPreferences.getInstance();
    return await _preferences.remove(key);
  }
}
