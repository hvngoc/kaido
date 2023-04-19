abstract class DetailListingEvent {}

class GetListingDetailEvent extends DetailListingEvent {
  final int listingId;

  GetListingDetailEvent({required this.listingId});
}

class GetListingInteractionEvent extends DetailListingEvent {
  final int listingId;

  GetListingInteractionEvent({required this.listingId});
}
