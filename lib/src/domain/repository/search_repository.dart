import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/data/model/search_property_type.dart';
import 'package:propzy_home/src/domain/model/category_home_listing.dart';
import 'package:propzy_home/src/domain/model/category_home_project.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';

import '../model/common_model.dart';
import '../model/common_model_1.dart';
import '../model/project_property_type_model.dart';
import '../model/property_type_model.dart';

abstract class SearchRepository {

  Future<BaseResponse<List<SearchGroupSuggestion>>> getLocationAutoComplete(
      String query, String type);

  Future<BaseResponse<List<SearchHistory>>> getSearchHistory();

  Future<BaseResponse<String?>> saveSearchHistory(SearchHistory searchHistory);

  Future<BaseResponse<PagingResponse<CategoryHomeListing>>>
      getCategoryHomeListing(CategorySearchRequest request);

  Future<BaseResponse<PagingResponse<CategoryHomeProject>>>
      getCategoryHomeProject(CategorySearchRequest request);

  Future<BaseResponse<List<PropertyType>>> getListPropertyTypesCategoryFilter(int? listingType);

  Future<BaseResponse<List<ProjectPropertyType>>> getListPropertyTypesForProjectCategoryFilter(int? listingType);

  Future<BaseResponse<List<Advantage>>> getListAdvantageCategoryFilter();

  Future<BaseResponse<List<BathRoom>>> getListBathroomCategoryFilter();

  Future<BaseResponse<List<BedRoom>>> getListBedroomCategoryFilter();

  Future<BaseResponse<List<Position>>> getListPositionCategoryFilter();

  Future<BaseResponse<List<Direction>>> getListDirectionCategoryFilter();

  Future<BaseResponse<List<Content>>> getListContentCategoryFilter();

  Future<BaseResponse<List<Amenity>>> getListAmenityCategoryFilter();

}
