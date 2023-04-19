import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';

abstract class AppDatabase {
  Future<void> insertDistricts(List<District> list);

  Future<void> insertWards(List<Ward> list);

  Future<void> insertStreets(List<Street> list);

  Future<List<District>?> getListDistrict(int cityId);

  Future<District?> getDistrict(int id);

  Future<bool> hasDistrict();

  Future<bool> hasWard();

  Future<bool> hasStreet();

  Future<List<Ward>?> getListWards(int districtId);

  Future<List<Street>?> getListStreets(int wardId);

  Future<Ward?> getWard(int id);

  Future<Street?> getStreetById(int streetId);
}
