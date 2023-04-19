import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/util/constants.dart';

abstract class AuthRepository {
  // Stream<UserInfo?> get currentUser;
  UserInfo? get currentUser;
  Future<UserInfo?> singleSignOn(SSOActionType actionType);
  Future<bool> reloadAccessToken();
  // void dispose();
  Future<void> signOut();
}