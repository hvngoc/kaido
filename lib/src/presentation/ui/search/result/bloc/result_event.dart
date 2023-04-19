import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';
import 'package:propzy_home/src/presentation/ui/search/result/sort_by_home.dart';

abstract class CategoryEvent {}

class GetLastSearchEvent extends CategoryEvent {
  GetLastSearchEvent() : super();
}

class GetListHomeEvent extends CategoryEvent {
  GetListHomeEvent() : super();
}

class UpdateLocationTag extends CategoryEvent {
  List<SearchHistory> location;

  UpdateLocationTag(this.location) : super();
}

class UpdateFilter extends CategoryEvent {
  List<SearchHistory> address;
  CategorySearchRequest request;

  UpdateFilter(this.address, this.request) : super();
}

class GetListHomeLoadMoreEvent extends CategoryEvent {
  GetListHomeLoadMoreEvent() : super();
}

class ChangeSortByEvent extends CategoryEvent {
  SortBy sortBy;

  ChangeSortByEvent(this.sortBy) : super();
}

class ResetFilterEvent extends CategoryEvent {}
class ResetPropertyTypeEvent extends CategoryEvent {}
class ResetAmenityEvent extends CategoryEvent {}
class ResetAdvantageEvent extends CategoryEvent {}
class ResetDirectionEvent extends CategoryEvent {}
class ResetStatusEvent extends CategoryEvent {}
class ResetBedroomsEvent extends CategoryEvent {}
class ResetBathroomsEvent extends CategoryEvent {}
class ResetContentEvent extends CategoryEvent {}
class ResetPropertyPositionEvent extends CategoryEvent {}
class ResetYearEvent extends CategoryEvent {}
class ResetPriceEvent extends CategoryEvent {}
class ResetSizeEvent extends CategoryEvent {}
