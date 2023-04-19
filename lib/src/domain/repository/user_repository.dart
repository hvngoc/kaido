import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/domain/model/delete_account_info.dart';
import 'package:propzy_home/src/domain/request/delete_account_request.dart';

abstract class UserRepository {
  Future<BaseResponse<UserInfo>> getProfile(
    String access_token,
  );
  Future<BaseResponse<DeleteAccountInfo?>> getDeletionInfo();
  Future<BaseResponse> sendDeleteRequest(
    DeleteAccountRequest request,
  );
  Future<BaseResponse> cancelDeletion();
}
