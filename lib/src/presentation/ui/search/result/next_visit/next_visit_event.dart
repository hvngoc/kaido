import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

abstract class NextVisitEvent {}

class NextLocalEvent extends NextVisitEvent {}

class NextSearchEvent extends NextVisitEvent {
  ChooserData? districtId = null;
  int? priceFrom = null;
  int? priceTo = null;
  ChooserData? propertyTypeId = null;

  NextSearchEvent({
    this.districtId,
    this.priceFrom,
    this.priceTo,
    this.propertyTypeId,
  });
}
