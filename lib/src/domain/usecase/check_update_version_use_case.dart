import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/repository/common_repository.dart';

class CheckUpdateVersionUseCase {
  final CommonRepository _commonRepository;

  CheckUpdateVersionUseCase(this._commonRepository);

  Future<BaseResponse> checkUpdateVersion() {
    return _commonRepository.checkUpdateVersion();
  }
}