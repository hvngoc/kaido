import 'package:propzy_home/src/domain/request/propzy_map_request.dart';

abstract class PickAddressEvent {}

class GetPropzyMapSessionEvent extends PickAddressEvent {}

class SearchAddressEvent extends PickAddressEvent {
  final String address;
  int page = 1;
  int size = 10;
  final int property_type_id;
  final String? sort;

  SearchAddressEvent(
    this.address,
    this.property_type_id,
    this.page,
    this.size,
    this.sort,
  );
}

class GetAddressInformationEvent extends PickAddressEvent {
  final PropzyMapInformationRequest request;

  GetAddressInformationEvent(this.request);
}

class PredictLocationEvent extends PickAddressEvent {
  final int streetId;

  PredictLocationEvent(this.streetId);
}

class SearchAddressWithStreetEvent extends PickAddressEvent {
  final int page;
  final int size;
  final SearchAddressWithStreetRequest request;

  SearchAddressWithStreetEvent(this.page, this.size, this.request);
}