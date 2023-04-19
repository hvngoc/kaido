import 'package:propzy_home/src/domain/model/listing_model.dart';

abstract class DetailListingState {}

class InitializeDetailListingState extends DetailListingState {}

class LoadingState extends DetailListingState {}

class ErrorState extends DetailListingState {
  final String? message;

  ErrorState({this.message = null});
}

class SuccessGetDetailListingState extends DetailListingState {
  final Listing? listing;

  SuccessGetDetailListingState(this.listing);
}

class ErrorGetDetailListingState extends ErrorState {}

class SuccessGetListingInteractionState extends DetailListingState {
  final ListingInteraction? listingInteraction;

  SuccessGetListingInteractionState(this.listingInteraction);
}
