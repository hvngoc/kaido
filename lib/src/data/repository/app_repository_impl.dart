import 'package:propzy_home/src/data/local/db/app_database.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/remote/api/app_service.dart';
import 'package:propzy_home/src/domain/model/category_properties.dart';
import 'package:propzy_home/src/domain/model/city.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';
import 'package:propzy_home/src/domain/repository/app_repository.dart';

class AppRepositoryImpl implements AppRepository {
  final AppService service;
  final AppDatabase databaseServices;

  AppRepositoryImpl(this.service, this.databaseServices);

  @override
  Future<BaseResponse<List<City>>> getListCity() {
    return Future.value(
      BaseResponse(
        result: true,
        data: [
          City(1, "Hồ Chí Minh"),
        ],
      ),
    );
  }

  @override
  Future<BaseResponse<List<District>>> getListDistrict(int cityId) async {
    final cached = await databaseServices.getListDistrict(cityId);
    if (cached != null) {
      return BaseResponse(result: true, data: cached);
    }
    return service.getListDistricts(cityId);
  }

  @override
  Future<BaseResponse<List<Ward>>> getListWard(int districtId) async {
    final cached = await databaseServices.getListWards(districtId);
    if (cached != null) {
      return BaseResponse(result: true, data: cached);
    }
    return service.getListWards(districtId);
  }

  @override
  Future<BaseResponse<List<Street>>> getListStreet(int wardId) async {
    final cached = await databaseServices.getListStreets(wardId);
    if (cached != null) {
      return BaseResponse(result: true, data: cached);
    }
    return service.getListStreets(wardId);
  }

  @override
  Future<BaseResponse<List<CategoryProperties>>> getListProperties(int type) {
    return service.getListProperties(type);
  }

  @override
  Future<bool> hasDistrict() {
    return databaseServices.hasDistrict();
  }

  @override
  Future<bool> hasWard() {
    return databaseServices.hasWard();
  }

  @override
  Future<bool> hasStreet() {
    return databaseServices.hasStreet();
  }

  @override
  Future<void> updateDistrict() async {
    final raw = await service.getListDistricts(-1);
    if (raw.data?.isNotEmpty == true) {
      databaseServices.insertDistricts(raw.data!);
    }
  }

  @override
  Future<void> updateWard() async {
    final raw = await service.getListWards(-1);
    if (raw.data?.isNotEmpty == true) {
      databaseServices.insertWards(raw.data!);
    }
  }

  @override
  Future<void> updateStreet() async {
    final raw = await service.getListStreets(-1);
    if (raw.data?.isNotEmpty == true) {
      databaseServices.insertStreets(raw.data!);
    }
  }

  @override
  Future<District?> getDistrictById(int districtId) {
    return databaseServices.getDistrict(districtId);
  }

  @override
  Future<Ward?> getWardById(int wardId) {
    return databaseServices.getWard(wardId);
  }

  @override
  Future<Street?> getStreetById(int streetId) async {
    final cached = await databaseServices.getStreetById(streetId);
    if (cached != null) {
      return cached;
    }
    final raw = await service.getStreetDetailById(streetId);
    if (raw.result == true) {
      return Future.value(raw.data);
    } else {
      return Future.value(null);
    }
  }
}
