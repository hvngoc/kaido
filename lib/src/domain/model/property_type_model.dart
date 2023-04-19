import 'package:json_annotation/json_annotation.dart';
import 'package:propzy_home/src/domain/model/project_property_type_model.dart';

part 'property_type_model.g.dart';

@JsonSerializable(checked: true)
class PropertyType {
  PropertyType({this.id, this.name, this.category, this.isChecked = false});

  dynamic id;
  String? name;
  String? category;
  bool? isChecked;


  factory PropertyType.fromJson(Map<String, dynamic> json) =>
      _$PropertyTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyTypeToJson(this);

  static final PropertyType HOME = PropertyType(category: "Nhà");
  static final PropertyType LAND = PropertyType(category: "Đất");
  static final PropertyType PROJECT = PropertyType(category: "Dự án");

}
