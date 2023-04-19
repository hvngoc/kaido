part of 'amenity_bloc.dart';

class UtilitiesState {
  const UtilitiesState();
}

class AmenityInitial extends UtilitiesState {}

class AmenityError extends UtilitiesState {}

class AmenityLoaded extends UtilitiesState {
  AmenityLoaded({this.data});

  final List<Amenity?>? data;

  bool isCheckedAll() =>
      (data?.every((element) => element?.isChecked == true)) == true ? true : false;

  AmenityLoaded copyWith({List<Amenity?>? data}) {
    return new AmenityLoaded(data: data ?? null);
  }
}
