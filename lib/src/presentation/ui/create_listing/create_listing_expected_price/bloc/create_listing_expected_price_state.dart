part of 'create_listing_expected_price_bloc.dart';

@immutable
abstract class CreateListingExpectedPriceState {}

class CreateListingExpectedPriceInitial extends CreateListingExpectedPriceState {}

class LoadingState extends CreateListingExpectedPriceState {}

class SuccessState extends CreateListingExpectedPriceState {}

class ErrorState extends CreateListingExpectedPriceState {
  final String? errorMessage;

  ErrorState({
    this.errorMessage = null,
  });
}