import 'package:json_annotation/json_annotation.dart';

part 'project_property_type_model.g.dart';

@JsonSerializable(checked: true)
class ProjectPropertyType {
  ProjectPropertyType({this.id, this.name, this.isChecked = false});

  int? id;
  String? name;
  bool? isChecked;

  factory ProjectPropertyType.fromJson(Map<String, dynamic> json) =>
      _$ProjectPropertyTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectPropertyTypeToJson(this);
}