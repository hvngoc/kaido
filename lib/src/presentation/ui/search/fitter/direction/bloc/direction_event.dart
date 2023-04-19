part of 'direction_bloc.dart';

abstract class DirectionEvent extends Equatable {
  const DirectionEvent();

  @override
  List<Object> get props => [];
}

class LoadDirectionEvent extends DirectionEvent {
  const LoadDirectionEvent({this.direction});

  final List<Direction?>? direction;
}

class CheckAllDirectionEvent extends DirectionEvent {}

class CheckItemDirectionEvent extends DirectionEvent {
  const CheckItemDirectionEvent({this.item, required this.index});

  final Direction? item;
  final int index;
}

class ResetAllDirectionEvent extends DirectionEvent {}

