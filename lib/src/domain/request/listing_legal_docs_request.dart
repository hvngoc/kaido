import 'package:json_annotation/json_annotation.dart';

part 'listing_legal_docs_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class ListingLegalDocsRequest {
  final int? id;
  final String currentStep;
  final int? priceForStatusQuo;
  final int? statusQuoId;
  final int? useRightTypeId;

  ListingLegalDocsRequest({
    this.id,
    this.priceForStatusQuo,
    this.statusQuoId,
    this.currentStep = 'LEGAL_DOCUMENTS_AND_STATUS_STEP',
    this.useRightTypeId,
  });

  factory ListingLegalDocsRequest.fromJson(Map<String, dynamic> json) =>
      _$ListingLegalDocsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListingLegalDocsRequestToJson(this);
}
