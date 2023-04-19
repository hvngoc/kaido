import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';

abstract class PropzyHomePropertyTypeState {}

class InitialPropzyHomePropertyTypeState extends PropzyHomePropertyTypeState {}

class LoadingState extends PropzyHomePropertyTypeState {}

class SuccessGetPropertyTypeState extends PropzyHomePropertyTypeState {
  final List<PropzyHomePropertyType>? propertyTypes;

  SuccessGetPropertyTypeState(this.propertyTypes);
}

class ErrorGetPropertyTypeState extends PropzyHomePropertyTypeState {
  final String? message;

  ErrorGetPropertyTypeState({this.message = null});
}
