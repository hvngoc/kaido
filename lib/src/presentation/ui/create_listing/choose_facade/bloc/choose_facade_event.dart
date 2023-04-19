part of 'choose_facade_bloc.dart';

abstract class ChooseFacadeEvent {}

class GetListAlleysEvent extends ChooseFacadeEvent {}

class UpdatePositionListingEvent extends ChooseFacadeEvent {
  ListingPositionRequest request;

  UpdatePositionListingEvent(this.request);
}