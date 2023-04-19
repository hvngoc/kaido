import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/category_properties.dart';
import 'package:propzy_home/src/domain/model/city.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';
import 'package:propzy_home/src/domain/repository/app_repository.dart';

abstract class GetChooserListUseCase<T> {
  Future<BaseResponse<List<T>>> getData(dynamic value);
}

class GetListCityUseCase extends GetChooserListUseCase<City> {
  late final AppRepository _repository;

  GetListCityUseCase(this._repository);

  @override
  Future<BaseResponse<List<City>>> getData(dynamic value) {
    return _repository.getListCity();
  }
}

class GetListDistrictUseCase extends GetChooserListUseCase<District> {
  late final AppRepository _repository;

  GetListDistrictUseCase(this._repository);

  @override
  Future<BaseResponse<List<District>>> getData(dynamic value) {
    return _repository.getListDistrict(1);
  }
}

class GetListWardUseCase extends GetChooserListUseCase<Ward> {
  late final AppRepository _repository;

  GetListWardUseCase(this._repository);

  @override
  Future<BaseResponse<List<Ward>>> getData(dynamic value) {
    return _repository.getListWard(value);
  }
}

class GetListStreetUseCase extends GetChooserListUseCase<Street> {
  late final AppRepository _repository;

  GetListStreetUseCase(this._repository);

  @override
  Future<BaseResponse<List<Street>>> getData(dynamic value) {
    return _repository.getListStreet(value);
  }
}

class GetListPropertyBuyUseCase extends GetChooserListUseCase<CategoryProperties> {
  late final AppRepository _repository;

  GetListPropertyBuyUseCase(this._repository);

  @override
  Future<BaseResponse<List<CategoryProperties>>> getData(dynamic value) {
    return _repository.getListProperties(1);
  }
}

class GetListPropertyRentUseCase extends GetChooserListUseCase<CategoryProperties> {
  late final AppRepository _repository;

  GetListPropertyRentUseCase(this._repository);

  @override
  Future<BaseResponse<List<CategoryProperties>>> getData(dynamic value) {
    return _repository.getListProperties(2);
  }
}
