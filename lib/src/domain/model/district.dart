import 'package:json_annotation/json_annotation.dart';

part 'district.g.dart';

@JsonSerializable(createToJson: true, checked: true)
class District {
  int? districtId;
  int? countryId;
  int? regionId;
  int? cityId;
  int? orders;

  String? districtName;
  String? districtShortName;
  String? districtNameEn;
  String? districtNameEnLower;
  String? districtNameLower;
  String? districtShortNameLower;
  String? districtSlug;

  District(
      this.districtId,
      this.countryId,
      this.regionId,
      this.cityId,
      this.orders,
      this.districtName,
      this.districtShortName,
      this.districtNameEn,
      this.districtNameEnLower,
      this.districtNameLower,
      this.districtShortNameLower,
      this.districtSlug);

  factory District.fromJson(Map<String, dynamic> json) => _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}
