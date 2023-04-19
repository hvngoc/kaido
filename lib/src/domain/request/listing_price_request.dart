import 'package:json_annotation/json_annotation.dart';

part 'listing_price_request.g.dart';

@JsonSerializable(createToJson: true, checked: true)
class ListingPriceRequest {
  int? id;
  String currentStep = 'PRICE_STEP';
  int? priceVND;

  ListingPriceRequest({
    this.id,
  });

  factory ListingPriceRequest.fromJson(Map<String, dynamic> json) =>
      _$ListingPriceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListingPriceRequestToJson(this);
}
