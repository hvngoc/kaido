import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_create_offer_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeCreateOfferRequest {
  int? userId;
  int? ownerTypeId;
  int? propertyTypeId;
  String? address;
  double? latitude;
  double? longitude;
  int? cityId;
  int? districtId;
  int? wardID;
  int? streetId;
  String? houseNumber;
  String? contactName;
  String? contactPhone;
  bool? unspecifiedLocation;
  int? blockBuildingId;
  String? blockBuildingName;
  int? buildingId;
  String? buildingName;
  int? reachedPageId;
  int? currentPage;

  PropzyHomeCreateOfferRequest({
    this.userId,
    this.ownerTypeId,
    this.propertyTypeId,
    this.address,
    this.latitude,
    this.longitude,
    this.cityId,
    this.districtId,
    this.wardID,
    this.streetId,
    this.houseNumber,
    this.contactName,
    this.contactPhone,
    this.unspecifiedLocation,
    this.blockBuildingId,
    this.blockBuildingName,
    this.reachedPageId,
    this.currentPage,
    this.buildingId,
    this.buildingName,
  });

  factory PropzyHomeCreateOfferRequest.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeCreateOfferRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeCreateOfferRequestToJson(this);
}
