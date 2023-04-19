import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/owner_type_model.dart';
import 'package:propzy_home/src/domain/repository/propzy_home_repository.dart';

class GetListOwnerTypeUseCase {
  late final PropzyHomeRepository _repository;

  GetListOwnerTypeUseCase(this._repository);

  Future<BaseResponse<List<OwnerType>>> getListOwnerType() {
    return _repository.getListOwnerType();
  }
}
