import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_offer_price_model.g.dart';

@JsonSerializable(checked: true)
class PropzyHomeOfferPriceModel {
  String? status;

  PropzyHomeOfferPriceModel({
    this.status,
  });

  factory PropzyHomeOfferPriceModel.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeOfferPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeOfferPriceModelToJson(this);
}
