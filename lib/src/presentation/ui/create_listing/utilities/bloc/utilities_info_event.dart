import 'package:propzy_home/src/domain/model/listing_model.dart';

abstract class UtilitiesInfoEvent {}

class UpdateUtilitiesInfoEvent extends UtilitiesInfoEvent {
  final UpdateUtilitiesListingRequest request;

  UpdateUtilitiesInfoEvent(this.request);
}

class LoadListAdvantageEvent extends UtilitiesInfoEvent {}

class LoadListAmenityEvent extends UtilitiesInfoEvent {}
