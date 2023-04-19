part of 'position_bloc.dart';

abstract class PositionEvent {
  const PositionEvent();
}

class LoadPositionEvent extends PositionEvent {
  const LoadPositionEvent(this.currentPosition);
  final Position? currentPosition;
}

class CheckItemPositionEvent extends PositionEvent {
  const CheckItemPositionEvent({this.item, required this.index});

  final Position? item;
  final int index;
}

class ResetAllPositionEvent extends PositionEvent {}
