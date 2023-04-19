import 'package:json_annotation/json_annotation.dart';

part 'listing_category_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class ListingCategoryRequest {
  final int listingTypeId;
  final int? propertyTypeId;
  final int id;
  final String currentStep;

  ListingCategoryRequest({
    required this.listingTypeId,
    required this.propertyTypeId,
    required this.id,
    this.currentStep = "DESCRIBE_STEP",
  });

  factory ListingCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$ListingCategoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListingCategoryRequestToJson(this);
}
