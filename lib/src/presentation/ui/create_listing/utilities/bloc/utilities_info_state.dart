import 'package:propzy_home/src/domain/model/common_model.dart';

abstract class UtilitiesInfoState {}

class InitialUtilitiesInfoState extends UtilitiesInfoState {}

class LoadingState extends UtilitiesInfoState {}

class ErrorState extends UtilitiesInfoState {
  final String? message;

  ErrorState(this.message);
}

class SuccessLoadListAdvantageState extends UtilitiesInfoState {
  final List<Advantage>? listAdvantages;

  SuccessLoadListAdvantageState(this.listAdvantages);
}

class SuccessLoadListAmenityState extends UtilitiesInfoState {
  final List<Amenity>? listAmenities;

  SuccessLoadListAmenityState(this.listAmenities);
}

class SuccessUpdateUtilitiesInfoState extends UtilitiesInfoState {}