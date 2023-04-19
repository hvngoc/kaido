import 'package:dio/dio.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/category_properties.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';
import 'package:retrofit/retrofit.dart';

part 'app_service.g.dart';

@RestApi()
abstract class AppService {
  factory AppService(Dio dio) = _AppService;

  @GET("propzy/api/districts/{cityId}")
  Future<BaseResponse<List<District>>> getListDistricts(@Path("cityId") int cityId);

  @GET("propzy/api/wards/{districtId}")
  Future<BaseResponse<List<Ward>>> getListWards(@Path("districtId") int districtId);

  @GET("propzy/api/streets/{wardId}")
  Future<BaseResponse<List<Street>>> getListStreets(@Path("wardId") int wardId);

  @GET("propzy/api/streets/street/{streetId}")
  Future<BaseResponse<Street>> getStreetDetailById(@Path("streetId") int streetId);

  @GET("frontoffice/api/common/property-type")
  Future<BaseResponse<List<CategoryProperties>>> getListProperties(
      @Query("listingType") int listingType);
}
