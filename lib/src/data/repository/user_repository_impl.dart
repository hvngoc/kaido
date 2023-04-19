import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/data/remote/api/user_service.dart';
import 'package:propzy_home/src/domain/model/delete_account_info.dart';
import 'package:propzy_home/src/domain/repository/user_repository.dart';
import 'package:propzy_home/src/domain/request/delete_account_request.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService service;

  UserRepositoryImpl(this.service);

  @override
  Future<BaseResponse<UserInfo>> getProfile(
    String access_token,
  ) {
    return service.getProfile(
      access_token,
    );
  }

  @override
  Future<BaseResponse<DeleteAccountInfo?>> getDeletionInfo() {
    // TODO: implement getDeletionInfo
    return service.getDeletionInfo();
  }

  @override
  Future<BaseResponse> sendDeleteRequest(
    DeleteAccountRequest request,
  ) {
    // TODO: implement sendDeleteRequest
    return service.sendDeleteRequest(
      request,
    );
  }

  @override
  Future<BaseResponse> cancelDeletion() {
    // TODO: implement cancelDeletion
    return service.cancelDeletion();
  }
}
