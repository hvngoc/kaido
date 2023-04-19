import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/repository/search_repository.dart';

class GetLocationAutoCompleteUseCase {
  late final SearchRepository _repository;
  GetLocationAutoCompleteUseCase(this._repository);
  Future<BaseResponse<List<SearchGroupSuggestion>>> getLocationAutoComplete(String query, String type) {
    return _repository.getLocationAutoComplete(query, type);
  }
}

class GetSearchHistoryUseCase {
  late final SearchRepository _repository;
  GetSearchHistoryUseCase(this._repository);
  Future<BaseResponse<List<SearchHistory>>> getSearchHistory() {
    return _repository.getSearchHistory();
  }
}

class SaveSearchHistoryUseCase {
  late final SearchRepository _repository;
  SaveSearchHistoryUseCase(this._repository);
  Future<BaseResponse<String?>> saveSearchHistory(SearchHistory searchHistory) {
    return _repository.saveSearchHistory(searchHistory);
  }
}