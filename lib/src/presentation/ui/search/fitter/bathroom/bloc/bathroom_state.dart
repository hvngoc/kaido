part of 'bathroom_bloc.dart';

class BathroomState {
  const BathroomState();
}

class BathroomInitial extends BathroomState {}

class BathroomError extends BathroomState {}

class BathroomLoaded extends BathroomState {
  BathroomLoaded({this.data});

  final List<BathRoom?>? data;

  bool isCheckedAll() => data?.first?.isSelected == true;

  BathroomLoaded copyWith({List<BathRoom?>? data}) {
    return new BathroomLoaded(data: data ?? null);
  }
}
