part of 'bedroom_bloc.dart';

class BedroomState {
  const BedroomState();
}

class BedroomInitial extends BedroomState {}

class BedroomError extends BedroomState {}

class BedroomLoaded extends BedroomState {
  BedroomLoaded({this.data});

  final List<BedRoom?>? data;

  bool isCheckedAll() => data?.first?.isSelected == true;

  BedroomLoaded copyWith({List<BedRoom?>? data}) {
    return new BedroomLoaded(data: data ?? null);
  }
}
