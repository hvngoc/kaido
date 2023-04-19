import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';

abstract class CategoryResultState {}

class LoadingState extends CategoryResultState {}

class EmptyState extends CategoryResultState {}

class SuccessState<T> extends CategoryResultState {
  final PagingResponse<T>? data;

  SuccessState(this.data);
}

class ErrorState extends CategoryResultState {
  final String? errorMessage;

  ErrorState(this.errorMessage);
}

class GetLastSearchSuccess extends CategoryResultState {
  final SearchHistory searchItemView;
  GetLastSearchSuccess(this.searchItemView);
}

