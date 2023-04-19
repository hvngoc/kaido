import 'package:json_annotation/json_annotation.dart';

part 'propzy_map_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class PropzyMapInformation {
  String? ref_id = "dashboard.search.1";
  String? location;
  int? building_id;
  int? block_building_id;

  PropzyMapInformation(
    this.location,
    this.building_id,
    this.block_building_id,
  );

  factory PropzyMapInformation.fromJson(Map<String, dynamic> json) =>
      _$PropzyMapInformationFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyMapInformationToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyMapInformationRequest {
  int? property_type_id;
  List<PropzyMapInformation>? request;

  PropzyMapInformationRequest(this.property_type_id, this.request);

  factory PropzyMapInformationRequest.fromJson(Map<String, dynamic> json) =>
      _$PropzyMapInformationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyMapInformationRequestToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class SearchAddressWithStreetRequest {
  int? streetId;
  String? keyword;

  SearchAddressWithStreetRequest({
    this.streetId,
    this.keyword,
  });

  factory SearchAddressWithStreetRequest.fromJson(Map<String, dynamic> json) => _$SearchAddressWithStreetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SearchAddressWithStreetRequestToJson(this);
}

