part of 'choose_building_bloc.dart';

abstract class ChooseBuildingState {}

class ChooseBuildingLoading extends ChooseBuildingState {}

class ChooseBuildingSuccess extends ChooseBuildingState {
  final List<ListingBuilding> listData;

  ChooseBuildingSuccess(this.listData);
}

class ChooseBuildingEmpty extends ChooseBuildingState {}
