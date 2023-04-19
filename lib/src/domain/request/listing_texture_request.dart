import 'package:json_annotation/json_annotation.dart';

part 'listing_texture_request.g.dart';

@JsonSerializable(createToJson: true, checked: true)
class ListingTextureRequest {
  int? id;
  String currentStep = 'TEXTURE_STEP';
  int numberFloor = 0;
  bool isMezzanine = false;
  bool isAttic = false;
  bool isRooftop = false;
  bool isPenthouse = false;
  bool isBasement = false;

  ListingTextureRequest({
    this.id,
  });

  factory ListingTextureRequest.fromJson(Map<String, dynamic> json) =>
      _$ListingTextureRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListingTextureRequestToJson(this);
}
