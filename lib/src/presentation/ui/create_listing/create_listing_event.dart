abstract class BaseCreateListingEvent {}

class UpdateListingEvent extends BaseCreateListingEvent {}

class CreateListingEvent extends BaseCreateListingEvent {}

class GetDraftListingDetailEvent extends BaseCreateListingEvent {
  final int listingId;

  GetDraftListingDetailEvent(this.listingId);
}