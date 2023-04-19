part of 'choose_project_info_bloc.dart';

abstract class ChooseProjectInfoEvent {}

class GetListBuildingsEvent extends ChooseProjectInfoEvent {
  int districtId;

  GetListBuildingsEvent(this.districtId);
}

class UpdateProjectInfoListingEvent extends ChooseProjectInfoEvent {
  ListingPositionRequest request;

  UpdateProjectInfoListingEvent(this.request);
}