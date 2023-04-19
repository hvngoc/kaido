part of 'map_info_card_bloc.dart';

@immutable
abstract class MapInfoCardEvent {}

class GetListingInDistanceEvent extends MapInfoCardEvent {
  final int tag;

  GetListingInDistanceEvent({required this.tag});
}