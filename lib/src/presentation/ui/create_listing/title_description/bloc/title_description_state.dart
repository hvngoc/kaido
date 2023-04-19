part of 'title_description_bloc.dart';

abstract class TitleDescriptionState {}

class TitleDescriptionLoading extends TitleDescriptionState {}

class UpdateTitleDescriptionStepSuccess extends TitleDescriptionState {}

class UpdateTitleDescriptionStepFail extends TitleDescriptionState {
  String error = '';

  UpdateTitleDescriptionStepFail(this.error);
}