import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_feature.g.dart';

@JsonSerializable(checked: true)
class HomeFeature {
  int? id;
  String? name;
  bool isChecked = false;
  List<HomeFeatureChildren>? chill;

  HomeFeature(this.id, this.name, this.chill, {this.isChecked = false});

  factory HomeFeature.fromJson(Map<String, dynamic> json) =>
      _$HomeFeatureFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFeatureToJson(this);
}

@JsonSerializable(checked: true)
class HomeFeatureChildren {
  int? id;
  String? name;
  bool isChecked = false;

  HomeFeatureChildren(this.id, this.name, {this.isChecked = false});

  factory HomeFeatureChildren.fromJson(Map<String, dynamic> json) =>
      _$HomeFeatureChildrenFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFeatureChildrenToJson(this);
}
