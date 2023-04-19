import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_contiguous.g.dart';

@JsonSerializable(checked: true)
class HomeContiguous {
  int? id;
  int? facadeType;
  String? name;

  HomeContiguous(this.id, this.name);

  factory HomeContiguous.fromJson(Map<String, dynamic> json) =>
      _$HomeContiguousFromJson(json);

  Map<String, dynamic> toJson() => _$HomeContiguousToJson(this);
}