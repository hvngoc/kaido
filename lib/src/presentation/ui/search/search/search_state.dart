import 'package:propzy_home/src/data/model/search_model.dart';

class SearchState {}

class InitializeSearchState extends SearchState {}

class SuccessSaveSearchHistoryState extends SearchState {
  SuccessSaveSearchHistoryState();
}

class ErrorSaveSearchHistoryState extends SearchState {
  final String? errorMessage;

  ErrorSaveSearchHistoryState(this.errorMessage);
}

class LoadingGetSearchHistoryState extends SearchState {}

class SuccessGetSearchHistoryState extends SearchState {
  final List<SearchHistory> data;

  SuccessGetSearchHistoryState(this.data);
}

class ErrorGetSearchHistoryState extends SearchState {
  final String? errorMessage;

  ErrorGetSearchHistoryState(this.errorMessage);
}

class StartGetLocationAutoCompleteState extends SearchState {
  StartGetLocationAutoCompleteState();
}

class SuccessGetLocationAutoCompleteState extends SearchState {
  final List<SearchGroupSuggestion> data;

  SuccessGetLocationAutoCompleteState(this.data);
}

class ErrorGetLocationAutoCompleteState extends SearchState {
  final String? errorMessage;

  ErrorGetLocationAutoCompleteState(this.errorMessage);
}
