part of 'create_listing_texture_bloc.dart';

@immutable
abstract class CreateListingTextureState {}

class CreateListingTextureInitial extends CreateListingTextureState {}

class LoadingState extends CreateListingTextureState {}

class SuccessState extends CreateListingTextureState {}

class ErrorState extends CreateListingTextureState {
  final String? errorMessage;

  ErrorState({
    this.errorMessage = null,
  });
}
