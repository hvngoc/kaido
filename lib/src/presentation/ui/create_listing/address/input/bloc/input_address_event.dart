import 'package:propzy_home/src/domain/model/listing_model.dart';

abstract class InputAddressEvent {}

class SearchAddressEvent extends InputAddressEvent {
  final String textSearch;

  SearchAddressEvent(this.textSearch);
}

class GetLocationInformationEvent extends InputAddressEvent {
  final String location;

  GetLocationInformationEvent(this.location);
}

class PredictLocationEvent extends InputAddressEvent {
  final int streetId;

  PredictLocationEvent(this.streetId);
}

class UpdateListingAddressEvent extends InputAddressEvent {
  final CreateListingRequest request;

  UpdateListingAddressEvent(this.request);
}