
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/remote/api/ibuy_service.dart';
import 'package:propzy_home/src/domain/repository/common_repository.dart';

class CommonRepositoryImpl implements CommonRepository {
  final IbuyService service;

  CommonRepositoryImpl(this.service);

  @override
  Future<BaseResponse> checkUpdateVersion() {
    return service.checkUpdateVersion();
  }
}

// class SearchRepositoryImpl implements SearchRepository {
//   late final SearchService service;
//
//   SearchRepositoryImpl(this.service);
//
//   @override
//   Future<BaseResponse<List<SearchPropertyType>>> getListPropertyTypesForProjectCategory(
//       int listingType) {
//     return service.getListPropertyTypesForProjectCategoryFilter(listingType);
//   }
//
//   @override
//   Future<BaseResponse<PagingResponse<CategoryHomeListing>>> getCategoryHomeListing(
//       CategorySearchRequest request) {
//     return service.getHomeListing(
//       request.sortBy,
//       request.sortDirection,
//       request.page,
//       request.size,
//       request.listingTypeId,
//       request.lat,
//       request.lng,
//       request.cityIds,
//       request.districtIds,
//       request.wardIds,
//       request.streetIds,
//     );
//   }
//
//   @override
//   Future<BaseResponse<List<SearchGroupSuggestion>>> getLocationAutoComplete(
//       String query, String type) {
//     return service.getLocationAutoComplete(query, type);
//   }
//
//   @override
//   Future<BaseResponse<List<SearchHistory>>> getSearchHistory() {
//     return service.getSearchHistory();
//   }
//
//   @override
//   Future<BaseResponse<String?>> saveSearchHistory(SearchHistory searchHistory) {
//     return service.saveSearchHistory(searchHistory);
//   }
// }