import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/domain/repository/user_repository.dart';

class GetProfileUseCase {
  late final UserRepository _repository;

  GetProfileUseCase(this._repository);

  Future<BaseResponse<UserInfo>> getProfile(String access_token) {
    return _repository.getProfile(access_token);
  }
}