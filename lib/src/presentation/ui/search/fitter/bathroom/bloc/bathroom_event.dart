part of 'bathroom_bloc.dart';

abstract class BathroomEvent extends Equatable {
  const BathroomEvent();

  @override
  List<Object> get props => [];
}

class LoadBathRoomEvent extends BathroomEvent {
  const LoadBathRoomEvent(this.itemSelected);

  final BathRoom? itemSelected;

}

class CheckItemBathroomEvent extends BathroomEvent {
  const CheckItemBathroomEvent({this.item, required this.index});

  final BathRoom? item;
  final int index;
}


class ResetFilterBathRoomEvent extends BathroomEvent {}
