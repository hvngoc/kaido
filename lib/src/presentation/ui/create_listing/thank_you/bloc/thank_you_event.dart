import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class ThankYouEvent {
  ChooserData? districtId = null;
  int? priceFrom = null;
  int? priceTo = null;
  ChooserData? propertyTypeId = null;

  ThankYouEvent({
    this.districtId,
    this.priceFrom,
    this.priceTo,
    this.propertyTypeId,
  });
}
