import 'package:propzy_home/src/domain/model/listing_model.dart';

abstract class ConfirmMapAddressEvent {}

class UpdateMapListingEvent extends ConfirmMapAddressEvent {
  final UpdateMapListingRequest request;

  UpdateMapListingEvent(this.request);
}