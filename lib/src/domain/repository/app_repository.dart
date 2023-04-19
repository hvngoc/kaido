import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/category_properties.dart';
import 'package:propzy_home/src/domain/model/city.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';

abstract class AppRepository {
  Future<BaseResponse<List<City>>> getListCity();

  Future<BaseResponse<List<District>>> getListDistrict(int cityId);

  Future<BaseResponse<List<Ward>>> getListWard(int districtId);

  Future<BaseResponse<List<Street>>> getListStreet(int wardId);

  Future<bool> hasDistrict();

  Future<void> updateDistrict();

  Future<District?> getDistrictById(int districtId);

  Future<Ward?> getWardById(int wardId);

  Future<bool> hasWard();

  Future<void> updateWard();

  Future<void> updateStreet();

  Future<Street?> getStreetById(int streetId);

  Future<bool> hasStreet();

  Future<BaseResponse<List<CategoryProperties>>> getListProperties(int type);
}
