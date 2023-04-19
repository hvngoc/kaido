part of 'property_bloc.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object> get props => [];
}

class LoadPropertyEvent extends PropertyEvent {
  const LoadPropertyEvent(this.listingTypeId, this.categoryType, {this.propertyType});

  final int listingTypeId;
  final CategoryType categoryType;
  final List<PropertyType?>? propertyType;

  @override
  List<Object> get props => [categoryType];
}

class CheckAllPropertyEvent extends PropertyEvent {}

class CheckItemPropertyEvent extends PropertyEvent {
  const CheckItemPropertyEvent({this.item, required this.index});

  final PropertyType? item;
  final int index;
}

class ResetAllPropertyEvent extends PropertyEvent {}
