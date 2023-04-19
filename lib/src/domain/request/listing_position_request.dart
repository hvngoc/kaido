import 'package:json_annotation/json_annotation.dart';

part 'listing_position_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class ListingPositionRequest {
  int? id;
  String? currentStep;

  int? positionId;

  double? roadFrontageWidth;

  int? alleyId;
  double? roadFrontageDistanceFrom;
  double? roadFrontageDistanceTo;

  int? buildingId;
  String? buildingName;
  int? floor;
  String? modelCode;
  bool? isHideModelCode;

  ListingPositionRequest({
    this.id,
    this.currentStep,
    this.positionId,
    this.roadFrontageWidth,
    this.alleyId,
    this.roadFrontageDistanceFrom,
    this.roadFrontageDistanceTo,
    this.buildingId,
    this.buildingName,
    this.floor,
    this.modelCode,
    this.isHideModelCode,
  });

  factory ListingPositionRequest.fromJson(Map<String, dynamic> json) =>
      _$ListingPositionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListingPositionRequestToJson(this);
}
