import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/data/remote/api/search_service.dart';
import 'package:propzy_home/src/domain/model/category_home_listing.dart';
import 'package:propzy_home/src/domain/model/category_home_project.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/project_property_type_model.dart';
import 'package:propzy_home/src/domain/repository/search_repository.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';

import '../../domain/model/common_model.dart';
import '../../domain/model/common_model_1.dart';
import '../../domain/model/property_type_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  late final SearchService service;

  SearchRepositoryImpl(this.service);

  @override
  Future<BaseResponse<PagingResponse<CategoryHomeListing>>> getCategoryHomeListing(
      CategorySearchRequest request) {
    return service.getHomeListing(
      request.sortBy,
      request.sortDirection,
      request.page,
      request.size,
      request.listingTypeId,
      request.lat,
      request.lng,
      request.cityIds,
      request.districtIds,
      request.wardIds,
      request.streetIds,
      _getProperties(request.propertyTypeIds),
      _buildDirectionIds(request.directionIds),
      _buildAdvantageId(request.advantageIds),
      _buildAmenityId(request.amenityIds),
      request.bedrooms?.id,
      request.bathrooms?.id,
      request.propertyPosition?.id,
      request.contentId?.id,
      request.minPrice,
      request.maxPrice,
      request.minSize,
      request.maxSize,
      request.minYear,
      request.maxYear,
      request.statusIds,
    );
  }

  List<int?>? _buildAdvantageId(List<Advantage?>? advantageListSelected) {
    if (advantageListSelected == null || advantageListSelected.every((element) => element?.isChecked == true)) return null;
    List<int?>? result = [];
    advantageListSelected.forEach((element) {
      if (element?.isChecked == true) {
        result.add(element?.id);
      }
    });
    return result;
  }

  List<int>? _getProperties(List<PropertyType?>? data) {
    if (data == null || data.every((element) => element?.isChecked == true)) return null;
    List<int>? result = [];
    data.forEach((element) {
      if (element?.isChecked == true) {
        try {
          if (element?.id.runtimeType == String) {
            if (element?.id?.contains(",") == true) {
              List<String> stringIds = element!.id!.split(",");
              stringIds.forEach((element) {
                result.add(int.parse(element));
              });
            } else {
              result.add(int.parse(element?.id ?? ''));
            }
          } else {
            result.add(element?.id);
          }
        } catch (e) {}
      }
    });
    return result;
  }

  List<int?>? _buildDirectionIds(List<Direction?>? directionListSelected) {
    if (directionListSelected == null || directionListSelected.every((element) => element?.isChecked == true)) return null;
    List<int?>? result = [];
    directionListSelected.forEach((element) {
      if (element?.isChecked == true) {
        result.add(element?.id);
      }
    });
    return result;
  }

  List<int?>? _buildAmenityId(List<Amenity?>? amenityListSelected) {
    if (amenityListSelected == null || amenityListSelected.every((element) => element?.isChecked == true)) return null;
    List<int?>? result = [];
    amenityListSelected.forEach((element) {
      if (element?.isChecked == true) {
        result.add(element?.id);
      }
    });
    return result;
  }


  Future<BaseResponse<PagingResponse<CategoryHomeProject>>> getCategoryHomeProject(
      CategorySearchRequest request) {
    return service.getHomeProject(
      request.sortBy,
      request.sortDirection,
      request.page,
      request.size,
      request.listingTypeId,
      request.lat,
      request.lng,
      request.cityIds,
      request.districtIds,
      request.wardIds,
      request.streetIds,
      _getProperties(request.propertyTypeIds),
      request.minPrice,
      request.maxPrice,
      request.minYear,
      request.maxYear,
      request.statusIds,
    );
  }

  @override
  Future<BaseResponse<List<SearchGroupSuggestion>>> getLocationAutoComplete(
      String query, String type) {
    return service.getLocationAutoComplete(query, type);
  }

  @override
  Future<BaseResponse<List<SearchHistory>>> getSearchHistory() {
    return service.getSearchHistory();
  }

  @override
  Future<BaseResponse<String?>> saveSearchHistory(SearchHistory searchHistory) {
    return service.saveSearchHistory(searchHistory);
  }

  @override
  Future<BaseResponse<List<BathRoom>>> getListBathroomCategoryFilter() {
    return service.getListBathroomCategoryFilter();
  }

  @override
  Future<BaseResponse<List<BedRoom>>> getListBedroomCategoryFilter() {
    return service.getListBedroomCategoryFilter();
  }

  @override
  Future<BaseResponse<List<Content>>> getListContentCategoryFilter() {
    return service.getListContentCategoryFilter();
  }

  @override
  Future<BaseResponse<List<Direction>>> getListDirectionCategoryFilter() {
    return service.getListDirectionCategoryFilter();
  }

  @override
  Future<BaseResponse<List<Position>>> getListPositionCategoryFilter() {
    return service.getListPositionCategoryFilter();
  }

  @override
  Future<BaseResponse<List<PropertyType>>> getListPropertyTypesCategoryFilter(int? listingType) {
    return service.getListPropertyTypesCategoryFilter(listingType);
  }

  @override
  Future<BaseResponse<List<ProjectPropertyType>>> getListPropertyTypesForProjectCategoryFilter(
      int? listingType) {
    return service.getListPropertyTypesForProjectCategoryFilter(listingType);
  }

  Future<BaseResponse<List<Advantage>>> getListAdvantageCategoryFilter() {
    return service.getListAdvantageCategoryFilter();
  }

  @override
  Future<BaseResponse<List<Amenity>>> getListAmenityCategoryFilter() {
    return service.getListAmenityCategoryFilter();
  }
}
