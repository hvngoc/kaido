import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/data/model/user_info.dart';

abstract class PrefHelper {
  Future<bool> firstRun();
  Future<void> setFirstRun(bool isFirstRun);

  Future<String?> getAccessToken();
  Future<void> setAccessToken(String token);
  Future<bool> removeAccessToken();

  Future<UserInfo?> getUserInfo();
  Future<void> setUserInfo(UserInfo? userInfo);
  Future<bool> removeUserInfo();

  Future<String?> getRefreshToken();
  Future<void> setRefreshToken(String token);
  Future<bool> removeRefreshToken();

  Future<bool> setOnBoardingStatus(bool value);
  Future<bool?> getOnBoardingStatus();

  Future<bool> setGuideMediaStatus(bool value);
  Future<bool?> getGuideMediaStatus();

  Future<bool> setGuideLegalStatus(bool value);
  Future<bool?> getGuideLegalStatus();

  Future<String?> getString(String key);
  Future setString(String key, String value);

  Future<int?> getInt(String key);
  Future setInt(String key, int value);

  Future<bool> removeData(String key);
}
