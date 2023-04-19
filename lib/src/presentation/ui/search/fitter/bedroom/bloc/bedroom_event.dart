part of 'bedroom_bloc.dart';

abstract class BedroomEvent extends Equatable {
  const BedroomEvent();

  @override
  List<Object> get props => [];
}

class LoadBedRoomEvent extends BedroomEvent {
  const LoadBedRoomEvent(this.itemSelected);

  final BedRoom? itemSelected;
}

class CheckItemBedroomEvent extends BedroomEvent {
  const CheckItemBedroomEvent({this.item, required this.index});

  final BedRoom? item;
  final int index;
}

class ResetFilterBedRoomEvent extends BedroomEvent {}

