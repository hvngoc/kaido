import 'package:json_annotation/json_annotation.dart';

part 'listing_status_quos.g.dart';

@JsonSerializable(createToJson: true, checked: true)
class StatusQuos {
  int? id;
  String? content;
  String? name;

  StatusQuos({this.id, this.content, this.name});

  factory StatusQuos.fromJson(Map<String, dynamic> json) => _$StatusQuosFromJson(json);

  Map<String, dynamic> toJson() => _$StatusQuosToJson(this);
}
