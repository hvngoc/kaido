import 'package:propzy_home/src/domain/model/listing_model.dart';

abstract class BaseCreateListingState {}

class ListingInitialState extends BaseCreateListingState {}

class ListingLoadingState extends BaseCreateListingState {}

class ErrorMessageState extends BaseCreateListingState {
  final String? errorMessage;

  ErrorMessageState(this.errorMessage);
}

class CreateListingSuccessState extends BaseCreateListingState {}

class GetDraftListingDetailSuccessState extends BaseCreateListingState {}
