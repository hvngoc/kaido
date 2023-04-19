import 'package:json_annotation/json_annotation.dart';

part 'search_property_type.g.dart';

@JsonSerializable(checked: true)
class SearchPropertyType {
  int? id;
  String? name;
  bool? isSelected = false;

  SearchPropertyType(
      {this.id, this.name, this.isSelected});

  factory SearchPropertyType.fromJson(Map<String, dynamic> json) => _$SearchPropertyTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPropertyTypeToJson(this);
}