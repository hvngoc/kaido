import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/domain/repository/auth_repository.dart';
import 'package:propzy_home/src/util/constants.dart';

class GetCurrentUserUseCase {
  late final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  // Stream<UserInfo?> get currentUser => _repository.currentUser;
  UserInfo? get currentUser => _repository.currentUser;

  // void dispose() {
  //   _repository.dispose();
  // }
}

class SingleSignOnUseCase {
  late final AuthRepository _repository;
  SingleSignOnUseCase(this._repository);

  Future<UserInfo?> singleSignOn(SSOActionType actionType) {
    return _repository.singleSignOn(actionType);
  }
}

class ReloadAccessTokenUseCase {
  late final AuthRepository _repository;
  ReloadAccessTokenUseCase(this._repository);

  Future<bool> reloadAccessToken() {
    return _repository.reloadAccessToken();
  }
}

class SignOutUseCase {
  late final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<void> signOut() {
    return _repository.signOut();
  }
}