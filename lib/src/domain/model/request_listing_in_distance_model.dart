import 'package:json_annotation/json_annotation.dart';

part 'request_listing_in_distance_model.g.dart';

@JsonSerializable(checked: true)
class RequestListingInDistanceModel {
  int? propertyTypeId;
  int? listingTypeId;
  int? cityId;
  double? distanceKm;
  double? latitude;
  double? longitude;

  RequestListingInDistanceModel({
    this.propertyTypeId,
    this.listingTypeId,
    this.cityId,
    this.distanceKm,
    this.latitude,
    this.longitude,
  });

  factory RequestListingInDistanceModel.fromJson(Map<String, dynamic> json) => _$RequestListingInDistanceModelFromJson(json);
  Map<String, dynamic> toJson() => _$RequestListingInDistanceModelToJson(this);
}
