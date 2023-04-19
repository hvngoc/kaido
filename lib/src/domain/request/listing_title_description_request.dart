import 'package:json_annotation/json_annotation.dart';

part 'listing_title_description_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class ListingTitleDescriptionRequest {
  final int id;
  final String currentStep;
  final String title;
  final String description;

  ListingTitleDescriptionRequest({
    required this.id,
    required this.currentStep,
    required this.title,
    required this.description,
  });

  factory ListingTitleDescriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$ListingTitleDescriptionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListingTitleDescriptionRequestToJson(this);
}
