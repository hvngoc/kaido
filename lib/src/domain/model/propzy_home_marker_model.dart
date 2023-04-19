import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_marker_model.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class PropzyHomeMarkerModel {
  int? listingId;
  double? latitude;
  double? longitude;
  double? price;
  String? formatPrice;

  PropzyHomeMarkerModel(
    this.listingId,
    this.latitude,
    this.longitude,
    this.price,
    this.formatPrice,
  );

  factory PropzyHomeMarkerModel.fromJson(Map<String, dynamic> json) => _$PropzyHomeMarkerModelFromJson(json);
}
