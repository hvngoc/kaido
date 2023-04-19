part of 'map_info_card_bloc.dart';

@immutable
abstract class MapInfoCardState {}

class InitialMapInfoCardState extends MapInfoCardState {}

class LoadingState extends MapInfoCardState {}

class MapInfoCardGetListingInDistanceSuccessState extends MapInfoCardState {
  final List<PropzyHomeMarkerModel> makers;
  MapInfoCardGetListingInDistanceSuccessState(this.makers);
}

class MapInfoCardGetListingInDistanceErrorState extends MapInfoCardState {
  final String? message;
  MapInfoCardGetListingInDistanceErrorState({this.message = null});
}
