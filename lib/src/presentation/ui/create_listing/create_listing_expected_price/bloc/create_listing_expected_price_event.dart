part of 'create_listing_expected_price_bloc.dart';

@immutable
abstract class CreateListingExpectedPriceEvent {}

class UpdateListingPriceEvent extends CreateListingExpectedPriceEvent {
  final ListingPriceRequest request;

  UpdateListingPriceEvent({
    required this.request,
  });
}
