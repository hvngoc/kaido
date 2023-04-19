import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class HomeEvent {}

class CheckUpdateVersionEvent extends HomeEvent {}

class ReloadAccessTokenEvent extends HomeEvent {}

class GoToSearchEvent extends HomeEvent {
  ChooserData? districtId = null;
  int? priceFrom = null;
  int? priceTo = null;
  ChooserData? propertyTypeId = null;

  GoToSearchEvent({
    this.districtId,
    this.priceFrom,
    this.priceTo,
    this.propertyTypeId,
  });
}
