part of 'amenity_bloc.dart';

abstract class AmenityEvent extends Equatable {
  const AmenityEvent();

  @override
  List<Object> get props => [];
}

class LoadAmenityEvent extends AmenityEvent {
  const LoadAmenityEvent({this.amenity});
  final List<Amenity?>? amenity;
}

class CheckAllAmenityEvent extends AmenityEvent {

}

class CheckItemAmenityEvent extends AmenityEvent {
  const CheckItemAmenityEvent({this.item, required this.index});

  final Amenity? item;
  final int index;
}

class ResetFilterAmenityEvent extends AmenityEvent {}

