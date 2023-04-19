part of 'choose_building_bloc.dart';

abstract class ChooseBuildingEvent {}

class LoadDataEvent extends ChooseBuildingEvent {
  final int districtId;

  LoadDataEvent(this.districtId);
}

class SearchNameEvent extends ChooseBuildingEvent {
  final String? name;

  SearchNameEvent(this.name);
}
