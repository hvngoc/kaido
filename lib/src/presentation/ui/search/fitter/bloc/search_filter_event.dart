class SearchFilterEvent {
  filter? type;

  SearchFilterEvent({this.type});
}

class LoadData extends SearchFilterEvent {
  LoadData() : super();
}

class InitData extends SearchFilterEvent {
  InitData({required filter type}) : super(type: type);
}

class ResetFilterSearchEvent extends SearchFilterEvent {
  ResetFilterSearchEvent() : super();
}

enum filter { buy, sell, project }
