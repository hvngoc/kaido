import 'package:json_annotation/json_annotation.dart';

part 'listing_alley.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class ListingAlley {
  int? id;
  String? name;

  ListingAlley({
    this.id,
    this.name,
  });

  factory ListingAlley.fromJson(Map<String, dynamic> json) => _$ListingAlleyFromJson(json);
}
