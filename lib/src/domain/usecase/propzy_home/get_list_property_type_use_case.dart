import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/domain/repository/propzy_home_repository.dart';

class GetListPropertyTypeUseCase {
  late final PropzyHomeRepository _repository;

  GetListPropertyTypeUseCase(this._repository);

  Future<BaseResponse<List<PropzyHomePropertyType>>> getListPropertyType() {
    return _repository.getListPropertyType();
  }
}
