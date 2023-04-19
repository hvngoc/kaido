import 'package:json_annotation/json_annotation.dart';
import 'package:propzy_home/src/domain/model/project_property_type_model.dart';

part 'owner_type_model.g.dart';

@JsonSerializable(checked: true)
class OwnerType {
  OwnerType({this.id, this.name, this.isSelected = false});

  int? id;
  String? name;
  bool? isSelected;

  factory OwnerType.fromJson(Map<String, dynamic> json) =>
      _$OwnerTypeFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerTypeToJson(this);
}
