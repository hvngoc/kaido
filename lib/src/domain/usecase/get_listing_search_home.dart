import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/category_home_listing.dart';
import 'package:propzy_home/src/domain/model/category_home_project.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/repository/search_repository.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';

abstract class BaseGetListingSearchUseCase<T> {
  Future<BaseResponse<PagingResponse<T>>> getListing(CategorySearchRequest request);
}

class GetListingSearchHomeUseCase extends BaseGetListingSearchUseCase<CategoryHomeListing> {
  late final SearchRepository _repository;

  GetListingSearchHomeUseCase(this._repository);

  @override
  Future<BaseResponse<PagingResponse<CategoryHomeListing>>> getListing(
      CategorySearchRequest request) {
    return _repository.getCategoryHomeListing(request);
  }
}

class GetCategoryProjectSearchHomeUseCase extends BaseGetListingSearchUseCase<CategoryHomeProject> {
  late final SearchRepository _repository;

  GetCategoryProjectSearchHomeUseCase(this._repository);

  @override
  Future<BaseResponse<PagingResponse<CategoryHomeProject>>> getListing(CategorySearchRequest request) {
    return _repository.getCategoryHomeProject(request);
  }
}