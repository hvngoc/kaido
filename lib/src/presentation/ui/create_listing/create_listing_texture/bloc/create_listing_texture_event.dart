part of 'create_listing_texture_bloc.dart';

@immutable
abstract class CreateListingTextureEvent {}

class UpdateTextureEvent extends CreateListingTextureEvent {
  final ListingTextureRequest request;

  UpdateTextureEvent({
    required this.request,
  });
}
