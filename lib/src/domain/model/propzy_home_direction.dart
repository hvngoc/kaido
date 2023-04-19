import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_direction.g.dart';

@JsonSerializable(checked: true)
class HomeDirection {
  int? id;
  String? name;

  HomeDirection(this.id, this.name);

  factory HomeDirection.fromJson(Map<String, dynamic> json) =>
      _$HomeDirectionFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDirectionToJson(this);
}