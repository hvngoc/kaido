import 'package:json_annotation/json_annotation.dart';

part 'listing_location.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class Location {
  double? lat;
  double? lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}
