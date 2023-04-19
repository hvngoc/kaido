import 'package:propzy_home/src/data/model/search_model.dart';

enum SearchEventType {
  initial_state,
  get_search_history,
  save_search_history,
  get_location_auto_complete
}

class SearchEvent {
  final SearchEventType searchEventType;

  SearchEvent(this.searchEventType);
}

class SaveSearchHistoryEvent extends SearchEvent {
  final SearchHistory searchHistory;
  final SearchHistory searchItemView;
  SaveSearchHistoryEvent(this.searchHistory, this.searchItemView) : super(SearchEventType.save_search_history);
}

class GetSearchHistoryEvent extends SearchEvent {
  GetSearchHistoryEvent() : super(SearchEventType.get_search_history);
}

class GetLocationAutoCompleteEvent extends SearchEvent {
  final String query;
  final String type;

  GetLocationAutoCompleteEvent(this.query, this.type) : super(SearchEventType.get_location_auto_complete);
}
