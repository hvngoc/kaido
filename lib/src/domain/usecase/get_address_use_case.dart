import 'package:propzy_home/src/domain/model/city.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';
import 'package:propzy_home/src/domain/repository/app_repository.dart';

class GetDistrictUseCase {
  late final AppRepository _repository;

  GetDistrictUseCase(this._repository);

  Future<District?> call(int districtId) {
    return _repository.getDistrictById(districtId);
  }
}

class GetWardUseCase {
  late final AppRepository _repository;

  GetWardUseCase(this._repository);

  Future<Ward?> call(int wardId) {
    return _repository.getWardById(wardId);
  }
}

class GetStreetUseCase {
  late final AppRepository _repository;

  GetStreetUseCase(this._repository);

  Future<Street?> call(int streetId) {
    return _repository.getStreetById(streetId);
  }
}
