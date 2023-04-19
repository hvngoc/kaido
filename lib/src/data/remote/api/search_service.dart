import 'package:dio/dio.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/model/category_home_listing.dart';
import 'package:propzy_home/src/domain/model/category_home_project.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/project_property_type_model.dart';
import 'package:retrofit/http.dart';

import '../../../domain/model/common_model.dart';
import '../../../domain/model/common_model_1.dart';
import '../../../domain/model/property_type_model.dart';

part 'search_service.g.dart';

@RestApi()
abstract class SearchService {
  factory SearchService(Dio dio) = _SearchService;

  @GET("portal-search/api/suggestion/location-autocomplete")
  Future<BaseResponse<List<SearchGroupSuggestion>>> getLocationAutoComplete(
      @Query("query") String query, @Query("type") String type);

  @GET("frontoffice/api/search-history")
  Future<BaseResponse<List<SearchHistory>>> getSearchHistory();

  @POST("frontoffice/api/search-history")
  Future<BaseResponse<String?>> saveSearchHistory(
      @Body(nullToAbsent: true) SearchHistory searchHistory);

  @GET("portal-search/api/listings")
  Future<BaseResponse<PagingResponse<CategoryHomeListing>>> getHomeListing(
    @Query("sortBy") String? sortBy,
    @Query("sortDirection") String? sortDirection,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("listingTypeId") int? listingTypeId,
    @Query("lat") double? lat,
    @Query("lng") double? lng,
    @Query("cityIds") List<int>? cityIds,
    @Query("districtIds") List<int>? districtIds,
    @Query("wardIds") List<int>? wardIds,
    @Query("streetIds") List<int>? streetIds,
    @Query("propertyTypeIds") List<int>? propertyTypeIds,
    @Query("directionIds") List<int?>? directionIds,
    @Query("advantageIds") List<int?>? advantageIds,
    @Query("amenityIds") List<int?>? amenityIds,
    @Query("bedrooms") int? bedrooms,
    @Query("bathrooms") int? bathrooms,
    @Query("propertyPosition") int? propertyPosition,
    @Query("contentId") int? contentId,
    @Query("minPrice") double? minPrice,
    @Query("maxPrice") double? maxPrice,
    @Query("minSize") double? minSize,
    @Query("maxSize") double? maxSize,
    @Query("minYear") int? minYear,
    @Query("maxYear") int? maxYear,
    @Query("statusIds") List<int>? statusIds,
  );

  @GET("portal-search/api/projects")
  Future<BaseResponse<PagingResponse<CategoryHomeProject>>> getHomeProject(
    @Query("sortBy") String? sortBy,
    @Query("sortDirection") String? sortDirection,
    @Query("page") int? page,
    @Query("size") int? size,
    @Query("listingTypeId") int? listingTypeId,
    @Query("lat") double? lat,
    @Query("lng") double? lng,
    @Query("cityIds") List<int>? cityIds,
    @Query("districtIds") List<int>? districtIds,
    @Query("wardIds") List<int>? wardIds,
    @Query("streetIds") List<int>? streetIds,
    @Query("propertyTypeIds") List<int>? propertyTypeIds,
    @Query("minPrice") double? minPrice,
    @Query("maxPrice") double? maxPrice,
    @Query("minYear") int? minYear,
    @Query("maxYear") int? maxYear,
    @Query("statusIds") List<int>? statusIds,
  );

  @GET("frontoffice/api/common/advantage/list")
  Future<BaseResponse<List<Advantage>>> getListAdvantageCategoryFilter();

  @GET("frontoffice/api/common/property-type")
  Future<BaseResponse<List<PropertyType>>> getListPropertyTypesCategoryFilter(@Query("listingType") int? listingType);

  @GET("frontoffice/api/common/bathroom/list")
  Future<BaseResponse<List<BathRoom>>> getListBathroomCategoryFilter();

  @GET("frontoffice/api/common/bedroom/list")
  Future<BaseResponse<List<BedRoom>>> getListBedroomCategoryFilter();

  @GET("frontoffice/api/common/position/list")
  Future<BaseResponse<List<Position>>> getListPositionCategoryFilter();

  @GET("frontoffice/api/common/direction/list")
  Future<BaseResponse<List<Direction>>> getListDirectionCategoryFilter();

  @GET("frontoffice/api/common/content/list")
  Future<BaseResponse<List<Content>>> getListContentCategoryFilter();

  @GET("frontoffice/api/common/amenity/list")
  Future<BaseResponse<List<Amenity>>> getListAmenityCategoryFilter();

  @GET("frontoffice/api/common/project/property-type")
  Future<BaseResponse<List<ProjectPropertyType>>> getListPropertyTypesForProjectCategoryFilter(@Query("listingType") int? listingType);
}
