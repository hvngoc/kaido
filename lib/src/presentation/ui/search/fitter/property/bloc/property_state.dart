part of 'property_bloc.dart';

class PropertyState {
  const PropertyState();
}

class PropertyInitial extends PropertyState {}

class PropertyError extends PropertyState {}

class PropertyLoaded extends PropertyState {
  PropertyLoaded({this.data});

  final List<PropertyType?>? data;

  bool isCheckedAll() => (data?.every((element) => element?.isChecked == true)) == true ? true : false;

  PropertyLoaded copyWith({List<PropertyType?>? data}) {
    return new PropertyLoaded(data: data ?? null);
  }
}
