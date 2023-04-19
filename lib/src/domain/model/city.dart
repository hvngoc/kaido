import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class City {
  int? cityId;
  String? cityName;

  City(
    this.cityId,
    this.cityName,
  );

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
