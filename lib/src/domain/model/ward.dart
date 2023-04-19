import 'package:json_annotation/json_annotation.dart';

part 'ward.g.dart';

@JsonSerializable(createToJson: true, checked: true)
class Ward {
  int? wardId;
  int? countryId;
  int? regionId;
  int? cityId;
  int? districtId;
  String? districtName;
  int? orders;

  String? wardName;
  String? wardShortName;
  String? wardNameEn;
  String? wardNameEnLower;
  String? wardNameLower;
  String? wardShortNameLower;
  String? wardSlug;

  double? latitude;
  double? longitude;

  Ward(
    this.wardId,
    this.countryId,
    this.regionId,
    this.cityId,
    this.districtId,
    this.districtName,
    this.orders,
    this.wardName,
    this.wardShortName,
    this.wardNameEn,
    this.wardNameEnLower,
    this.wardNameLower,
    this.wardShortNameLower,
    this.wardSlug,
    this.latitude,
    this.longitude,
  );

  factory Ward.fromJson(Map<String, dynamic> json) => _$WardFromJson(json);

  Map<String, dynamic> toJson() => _$WardToJson(this);
}
