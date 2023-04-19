part of 'direction_bloc.dart';

class DirectionState {
  const DirectionState();
}

class DirectionInitial extends DirectionState {}

class DirectionError extends DirectionState {}

class DirectionLoaded extends DirectionState {
  DirectionLoaded({this.data});

  final List<Direction?>? data;

  bool isCheckedAll() =>
      (data?.every((element) => element?.isChecked == true)) == true ? true : false;

  DirectionLoaded copyWith({List<Direction?>? data}) {
    return new DirectionLoaded(data: data ?? null);
  }
}
