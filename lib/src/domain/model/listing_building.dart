import 'package:json_annotation/json_annotation.dart';
import 'package:tiengviet/tiengviet.dart';

part 'listing_building.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class ListingBuilding {
  int? id;
  String? name;
  int? projectId;

  String get unsignedName => TiengViet.parse(this.name ?? '');

  ListingBuilding({
    this.id,
    this.name,
    this.projectId,
  });

  factory ListingBuilding.fromJson(Map<String, dynamic> json) => _$ListingBuildingFromJson(json);
}
