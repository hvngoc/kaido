import 'package:dio/dio.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/domain/model/delete_account_info.dart';
import 'package:propzy_home/src/domain/request/delete_account_request.dart';
import 'package:propzy_home/src/domain/request/login_request.dart';
import 'package:retrofit/retrofit.dart';

part 'user_service.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(Dio dio) = _UserService;

  @POST('propzy/api/v2/users/sign-in')
  Future<BaseResponse<UserInfo>> login(
    @Body() LoginDataRequest loginRequest,
  );

  @GET('propzy/api/users/profile')
  Future<BaseResponse<UserInfo>> getProfile(
    @Query('access_token') String access_token,
  );

  @GET('frontoffice/api/identity/user/deletion')
  Future<BaseResponse<DeleteAccountInfo?>> getDeletionInfo();

  @POST('frontoffice/api/identity/user/deletion')
  Future<BaseResponse> sendDeleteRequest(
    @Body() DeleteAccountRequest request,
  );

  @PUT('frontoffice/api/identity/user/deletion')
  Future<BaseResponse> cancelDeletion();
}
