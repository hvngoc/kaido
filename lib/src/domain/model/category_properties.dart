import 'package:json_annotation/json_annotation.dart';

part 'category_properties.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class CategoryProperties {
  final int? id;
  final String? name;

  CategoryProperties(this.id, this.name);

  factory CategoryProperties.fromJson(Map<String, dynamic> json) => _$CategoryPropertiesFromJson(json);

}
