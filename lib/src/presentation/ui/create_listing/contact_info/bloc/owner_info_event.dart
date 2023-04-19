import 'package:propzy_home/src/domain/model/listing_model.dart';

abstract class OwnerInfoEvent {}

class UpdateOwnerInfoEvent extends OwnerInfoEvent {
  final UpdateOwnerInfoListingRequest request;

  UpdateOwnerInfoEvent(this.request);
}