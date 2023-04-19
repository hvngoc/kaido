import 'package:json_annotation/json_annotation.dart';

part 'listing_plan_to_buy.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class ListingPlanToBuy {
  final int? id;
  final int? buyPlanOptionId;
  final String currentStep;
  final int? districtId;
  final int? priceFrom;
  final int? priceTo;
  final int? propertyTypeId;

  ListingPlanToBuy({
    this.id,
    this.buyPlanOptionId,
    this.currentStep = 'LOOKING_QUESTION_STEP',
    this.districtId,
    this.priceFrom,
    this.priceTo,
    this.propertyTypeId,
  });

  factory ListingPlanToBuy.fromJson(Map<String, dynamic> json) => _$ListingPlanToBuyFromJson(json);

  Map<String, dynamic> toJson() => _$ListingPlanToBuyToJson(this);
}
