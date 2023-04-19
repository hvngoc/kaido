import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/delete_account_info.dart';
import 'package:propzy_home/src/domain/repository/user_repository.dart';
import 'package:propzy_home/src/domain/request/delete_account_request.dart';

class DeleteAccountUseCase {
  late final UserRepository _repository;

  DeleteAccountUseCase(
    this._repository,
  );

  Future<BaseResponse<DeleteAccountInfo?>> getDeletionInfo() {
    return _repository.getDeletionInfo();
  }

  Future<BaseResponse> sendDeleteRequest(
    DeleteAccountRequest request,
  ) {
    return _repository.sendDeleteRequest(
      request,
    );
  }

  Future<BaseResponse> cancelDeletion() {
    return _repository.cancelDeletion();
  }
}
