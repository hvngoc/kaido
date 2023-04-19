import 'package:json_annotation/json_annotation.dart';

part 'listing_image_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class ListingImageRequest {
  int? id;
  String? currentStep;
  List<ListingMediaRequest>? media;

  ListingImageRequest({
    this.id,
    this.currentStep,
    this.media,
  });

  factory ListingImageRequest.fromJson(Map<String, dynamic> json) =>
      _$ListingImageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListingImageRequestToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class ListingMediaRequest {
  String? fileName;
  int? formatType;
  bool? isDefault;
  int? sourceType;

  ListingMediaRequest({
    this.fileName,
    this.formatType,
    this.isDefault,
    this.sourceType,
  });

  factory ListingMediaRequest.fromJson(Map<String, dynamic> json) =>
      _$ListingMediaRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListingMediaRequestToJson(this);

  @override
  String toString() {
    return '[fileName: $fileName - isDefault: $isDefault - sourceType: $sourceType]';
  }
}
