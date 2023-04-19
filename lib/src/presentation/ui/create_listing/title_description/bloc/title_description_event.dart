part of 'title_description_bloc.dart';

abstract class TitleDescriptionEvent {}

class UpdateTitleDescriptionStepEvent extends TitleDescriptionEvent {
  ListingTitleDescriptionRequest request;

  UpdateTitleDescriptionStepEvent(this.request);
}