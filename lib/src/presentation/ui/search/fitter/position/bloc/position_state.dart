part of 'position_bloc.dart';

class PositionState {
  const PositionState();
}

class PositionInitial extends PositionState {}

class PositionError extends PositionState {}

class PositionLoaded extends PositionState {
  PositionLoaded({this.data});

  final List<Position?>? data;

  bool isCheckedAll() => data?.first?.isSelected == true;

  PositionLoaded copyWith({List<Position?>? data}) {
    return new PositionLoaded(data: data ?? null);
  }
}
