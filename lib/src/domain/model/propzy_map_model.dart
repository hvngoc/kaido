import 'package:json_annotation/json_annotation.dart';

part 'propzy_map_model.g.dart';

@JsonSerializable(checked: true)
class PropzyMapSession {
  PropzyMapSession({
    this.session,
    this.expires_in,
  });

  String? session;
  int? expires_in;

  factory PropzyMapSession.fromJson(Map<String, dynamic> json) =>
      _$PropzyMapSessionFromJson(json);
}

@JsonSerializable(checked: true)
class AddressSearchContent {
  List<AddressSearch>? list;
  int? totalPages;
  int? totalItems;

  AddressSearchContent(
    this.list,
    this.totalItems,
    this.totalPages,
  );

  factory AddressSearchContent.fromJson(Map<String, dynamic> json) =>
      _$AddressSearchContentFromJson(json);
}

@JsonSerializable(checked: true)
class AddressSearch {
  int? id;
  String? ref_id;
  String? address;
  String? location;
  int? building_id;
  String? building_name;
  int? block_building_id;
  String? block_building_name;

  AddressSearch(
    this.id,
    this.ref_id,
    this.address,
    this.location,
    this.building_id,
    this.building_name,
    this.block_building_id,
    this.block_building_name,
  );

  factory AddressSearch.fromJson(Map<String, dynamic> json) =>
      _$AddressSearchFromJson(json);
}

@JsonSerializable(checked: true)
class AddressInformation {
  String? province_name;
  String? district_name;
  String? ward_name;
  String? street_name;
  String? address;
  int? city_id;
  int? district_id;
  int? ward_id;
  int? street_id;
  String? so_nha;
  int? building_id;
  String? building_name;
  int? block_building_id;
  String? block_building_name;

  AddressInformation(
    this.province_name,
    this.district_name,
    this.ward_name,
    this.street_name,
    this.address,
    this.city_id,
    this.district_id,
    this.ward_id,
    this.street_id,
    this.so_nha,
    this.building_id,
    this.building_name,
    this.block_building_id,
    this.block_building_name,
  );

  factory AddressInformation.fromJson(Map<String, dynamic> json) =>
      _$AddressInformationFromJson(json);
}

@JsonSerializable(checked: true)
class PredictLocation {
  Wgs84Center? wgs84_center;

  PredictLocation({
    this.wgs84_center,
  });

  factory PredictLocation.fromJson(Map<String, dynamic> json) =>
      _$PredictLocationFromJson(json);
}

@JsonSerializable(checked: true)
class Wgs84Center {
  List<String>? coordinates;
  String? type;

  Wgs84Center({
    this.coordinates,
    this.type,
  });

  factory Wgs84Center.fromJson(Map<String, dynamic> json) =>
      _$Wgs84CenterFromJson(json);
}

@JsonSerializable(checked: true)
class SearchAddressWithStreet {
  int? id;
  Wgs84Center? wgs84_center;
  String? house_number;

  SearchAddressWithStreet({
    this.id,
    this.wgs84_center,
    this.house_number,
  });

  factory SearchAddressWithStreet.fromJson(Map<String, dynamic> json) =>
      _$SearchAddressWithStreetFromJson(json);
}
