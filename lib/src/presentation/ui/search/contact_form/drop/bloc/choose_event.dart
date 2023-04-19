abstract class ChooserEvent {}

class LoadDataEvent extends ChooserEvent {
  final dynamic value;

  LoadDataEvent(this.value);
}

class SearchNameEvent extends ChooserEvent {
  final String? name;

  SearchNameEvent(this.name);
}
