import 'package:json_annotation/json_annotation.dart';

part 'street.g.dart';

@JsonSerializable(createToJson: true, checked: true)
class Street {
  int? streetId;
  int? countryId;
  int? regionId;
  int? cityId;
  int? districtId;
  int? wardId;
  String? streetName;

  String? streetNameEn;
  String? streetSlug;

  double? latitude;
  double? longitude;

  Street(
    this.streetId,
    this.countryId,
    this.regionId,
    this.cityId,
    this.districtId,
    this.wardId,
    this.streetName,
    this.streetNameEn,
    this.streetSlug,
    this.latitude,
    this.longitude,
  );

  factory Street.fromJson(Map<String, dynamic> json) => _$StreetFromJson(json);

  Map<String, dynamic> toJson() => _$StreetToJson(this);
}
