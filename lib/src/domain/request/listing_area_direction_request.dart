import 'package:json_annotation/json_annotation.dart';

part 'listing_area_direction_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class ListingAreaDirectionRequest {
  final int? id;
  final String currentStep;
  final int? bathrooms;
  final int? bedrooms;
  final int? directionId;
  final double? floorSize;
  final double? lotSize;
  final double? sizeLength;
  final double? sizeWidth;

  ListingAreaDirectionRequest({
    this.id,
    this.bathrooms,
    this.bedrooms,
    this.directionId,
    this.floorSize,
    this.lotSize,
    this.currentStep = 'AREA_AND_DIRECTION_STEP',
    this.sizeLength,
    this.sizeWidth,
  });

  factory ListingAreaDirectionRequest.fromJson(Map<String, dynamic> json) =>
      _$ListingAreaDirectionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListingAreaDirectionRequestToJson(this);
}
