import 'package:json_annotation/json_annotation.dart';
import 'package:propzy_home/src/domain/model/city.dart';
import 'package:propzy_home/src/domain/model/common_model.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/listing_alley.dart';
import 'package:propzy_home/src/domain/model/listing_building.dart';
import 'package:propzy_home/src/domain/model/listing_photo.dart';
import 'package:propzy_home/src/domain/model/property_type_model.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';

part 'listing_model.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class Listing {
  int? listingId;
  String? title;
  String? description;
  String? statusQuoName;
  String? useRightTypeName;
  double? floorSize;
  double? price;
  double? priceVND;
  String? directionName;
  String? wardName;
  String? wardSlug;
  String? districtName;
  String? districtSlug;
  String? streetName;
  String? streetSlug;
  String? cityName;
  String? citySlug;
  double? sizeWidth;
  double? sizeLength;
  int? yearBuilt;
  bool? isBasement;
  bool? isRooftop;
  bool? isMezzanine;
  bool? isPenthouse;
  bool? isGuaranteed;
  bool? isPrivate;
  bool? isAttic;
  int? listingTypeId;
  int? numberFloor;
  int? floors;
  double? size;
  double? unitLand;
  double? unitPrice;
  String? listingTypeName;
  int? facilityId;
  int? facilityValue;
  double? latitude;
  double? longitude;
  String? vrLink;
  String? tradedStatus;
  bool? useDefaultPhoto;
  int? statusID;
  int? statusDate;
  int? socialUid;
  int? liveType;
  int? classify;
  List<ListingPhoto>? photos;
  List<ListingPhoto>? photoGCNs;
  List<Amenity>? amenities;
  List<Advantage>? advantages;
  PropertyType? propertyType;
  ProjectInfo? project;
  String? formatFloors;
  String? priceTrend;
  String? labelCode;
  String? labelName;
  String? formatStructure;
  String? formatUnitLand;
  String? formatAddress;
  String? formatPriceVND;
  String? formatLotSize;
  String? formatFloorSize;
  String? formatSizeLength;
  String? formatSizeWidth;
  String? formatAlleyWidth;
  String? formatRoadFrontageWidth;
  String? formatBedrooms;
  String? formatBathrooms;
  String? formatNumberFloor;
  String? formatUnitPrice;
  String? formatSize;
  String? slug;

  Listing(
      {this.listingId,
      this.title,
      this.description,
      this.statusQuoName,
      this.useRightTypeName,
      this.floorSize,
      this.price,
      this.priceVND,
      this.directionName,
      this.wardName,
      this.wardSlug,
      this.districtName,
      this.districtSlug,
      this.streetName,
      this.streetSlug,
      this.cityName,
      this.citySlug,
      this.sizeWidth,
      this.sizeLength,
      this.yearBuilt,
      this.isBasement,
      this.isRooftop,
      this.isMezzanine,
      this.isPenthouse,
      this.isGuaranteed,
      this.isPrivate,
      this.isAttic,
      this.listingTypeId,
      this.numberFloor,
      this.floors,
      this.size,
      this.unitLand,
      this.unitPrice,
      this.listingTypeName,
      this.facilityId,
      this.facilityValue,
      this.latitude,
      this.longitude,
      this.vrLink,
      this.tradedStatus,
      this.useDefaultPhoto,
      this.statusID,
      this.statusDate,
      this.socialUid,
      this.liveType,
      this.classify,
      this.photos,
      this.photoGCNs,
      this.amenities,
      this.advantages,
      this.propertyType,
      this.project,
      this.formatFloors,
      this.priceTrend,
      this.labelCode,
      this.labelName,
      this.formatStructure,
      this.formatUnitLand,
      this.formatAddress,
      this.formatPriceVND,
      this.formatLotSize,
      this.formatFloorSize,
      this.formatSizeLength,
      this.formatSizeWidth,
      this.formatAlleyWidth,
      this.formatRoadFrontageWidth,
      this.formatBedrooms,
      this.formatBathrooms,
      this.formatNumberFloor,
      this.formatUnitPrice,
      this.formatSize,
      this.slug});

  factory Listing.fromJson(Map<String, dynamic> json) => _$ListingFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class ProjectInfo {
  int? id;
  String? projectName;
  String? address;
  String? investorName;
  int? numberOfBlocks;
  int? numberOfUnits;
  String? citySlug;
  String? districtSlug;
  String? slug;
  int? numberOfLiveListingForSale;
  int? numberOfLiveListingForRent;

  ProjectInfo({
    this.id,
    this.projectName,
    this.address,
    this.investorName,
    this.numberOfBlocks,
    this.numberOfUnits,
    this.citySlug,
    this.districtSlug,
    this.slug,
    this.numberOfLiveListingForSale,
    this.numberOfLiveListingForRent,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) => _$ProjectInfoFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class ListingInteraction {
  int? numberOfTours;
  int? numberOfShares;
  int? numberOfViews;
  int? numberOfFavorites;

  ListingInteraction({
    this.numberOfTours,
    this.numberOfShares,
    this.numberOfViews,
    this.numberOfFavorites,
  });

  factory ListingInteraction.fromJson(Map<String, dynamic> json) =>
      _$ListingInteractionFromJson(json);
}

class PriceTrendType {
  final String value;

  PriceTrendType(this.value);

  static final PriceTrendType UP = PriceTrendType("UP");
  static final PriceTrendType DOWN = PriceTrendType("DOWN");
}

@JsonSerializable(createToJson: false, checked: true)
class SearchAddress {
  final int? id;
  final String? address;
  final String? location;
  final bool isFakeLocation;

  SearchAddress(this.id, this.address, this.location, {this.isFakeLocation = false});

  factory SearchAddress.fromJson(Map<String, dynamic> json) => _$SearchAddressFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class AddressByLocation {
  final int? cityId;
  String? cityName;
  final int? districtId;
  String? districtName;
  final int? wardId;
  String? wardName;
  final int? streetId;
  String? streetName;
  final String? location;
  final String? houseNumber;

  AddressByLocation(
    this.cityId,
    this.cityName,
    this.districtId,
    this.districtName,
    this.wardId,
    this.wardName,
    this.streetId,
    this.streetName,
    this.location,
    this.houseNumber,
  );

  factory AddressByLocation.fromJson(Map<String, dynamic> json) =>
      _$AddressByLocationFromJson(json);
}

@JsonSerializable(createToJson: true, checked: true)
class CreateListingRequest {
  String? address;
  int? cityId;
  String? currentStep;
  int? districtId;
  String? houseNumber;
  int? id;
  bool isHideHouseNumber;
  double? latitude;
  double? longitude;
  int? sourceId;
  int? streetId;
  String? streetName;
  int? wardId;

  CreateListingRequest({
    this.address = null,
    this.cityId = null,
    this.currentStep = null,
    this.districtId = null,
    this.houseNumber = null,
    this.id = null,
    required this.isHideHouseNumber,
    this.latitude = null,
    this.longitude = null,
    this.sourceId = null,
    this.streetId = null,
    this.streetName = null,
    this.wardId = null,
  });

  factory CreateListingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateListingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateListingRequestToJson(this);
}

@JsonSerializable(createToJson: false, checked: true)
class CreateListingResponse {
  final int? id;

  factory CreateListingResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateListingResponseFromJson(json);

  CreateListingResponse(this.id);
}

@JsonSerializable(createToJson: true, checked: true)
class UpdateMapListingRequest {
  final int id;
  final String currentStep;
  final double? latitude;
  final double? longitude;

  UpdateMapListingRequest({
    required this.id,
    this.latitude,
    this.longitude,
    this.currentStep = "MAP_STEP",
  });

  factory UpdateMapListingRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMapListingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMapListingRequestToJson(this);
}

@JsonSerializable(createToJson: true, checked: true)
class UpdateOwnerInfoListingRequest {
  final int id;
  final String currentStep;
  final String ownerName;
  final String ownerPhone;
  final String? ownerEmail;

  UpdateOwnerInfoListingRequest({
    required this.id,
    required this.ownerName,
    required this.ownerPhone,
    this.ownerEmail,
    this.currentStep = "OWNER_INFORMATION_STEP",
  });

  factory UpdateOwnerInfoListingRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOwnerInfoListingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOwnerInfoListingRequestToJson(this);
}

@JsonSerializable(createToJson: true, checked: true)
class UpdateUtilitiesListingRequest {
  final int id;
  final String currentStep;
  final List<int> utilities;
  final String? content;

  UpdateUtilitiesListingRequest({
    required this.id,
    required this.utilities,
    this.content,
    this.currentStep = "MORE_INFORMATION_STEP",
  });

  factory UpdateUtilitiesListingRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUtilitiesListingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUtilitiesListingRequestToJson(this);
}

@JsonSerializable(createToJson: false, checked: true)
class DraftListing {
  final int? id;
  final double? latitude;
  final double? longitude;
  final City? city;
  final District? district;
  final Ward? ward;
  final Street? street;
  final String? streetName;
  final String? houseNumber;
  final bool? isHideHouseNumber;
  final String? address;
  final ListingType? listingType;
  final PropertyTypeDraftListing? propertyType;
  final int? numberFloor;
  final bool? isMezzanine;
  final bool? isRooftop;
  final bool? isAttic;
  final bool? isPenthouse;
  final bool? isBasement;
  final bool? isHideModelCode;
  final double? sizeLength;
  final double? sizeWidth;
  final double? lotSize;
  final double? floorSize;
  final int? bedrooms;
  final int? bathrooms;
  final Direction? direction;
  final UseRightType? useRightType;
  final StatusQuo? statusQuo;
  final double? priceForStatusQuo;
  final List<UtilitiesCategory>? utilities;
  final List<MediaListing>? media;
  final double? priceVND;
  final String? title;
  final String? description;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;
  final String? currentStep;
  final bool? isCompleted;
  final int? createdDate;
  final int? updatedDate;
  final LsoListingDraftPosition? lsoListingDraftPosition;
  final BuyPlan? buyPlan;
  final String? modelCode;
  final ListingBuilding? building;
  final int? floor;

  DraftListing(
    this.id,
    this.latitude,
    this.longitude,
    this.city,
    this.district,
    this.ward,
    this.street,
    this.streetName,
    this.houseNumber,
    this.isHideHouseNumber,
    this.address,
    this.listingType,
    this.propertyType,
    this.numberFloor,
    this.isMezzanine,
    this.isRooftop,
    this.isAttic,
    this.isPenthouse,
    this.isBasement,
    this.isHideModelCode,
    this.sizeLength,
    this.sizeWidth,
    this.lotSize,
    this.floorSize,
    this.bedrooms,
    this.bathrooms,
    this.direction,
    this.useRightType,
    this.statusQuo,
    this.priceForStatusQuo,
    this.utilities,
    this.media,
    this.priceVND,
    this.title,
    this.description,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    this.currentStep,
    this.isCompleted,
    this.createdDate,
    this.updatedDate,
    this.lsoListingDraftPosition,
    this.buyPlan,
    this.modelCode,
    this.building,
    this.floor,
  );

  factory DraftListing.fromJson(Map<String, dynamic> json) => _$DraftListingFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class ListingType {
  final int? listingTypeID;
  final int? parentID;
  final String? typeName;
  final String? typeNameEn;
  final String? slug;
  final bool? deleted;
  final dynamic? createdDate;
  final dynamic? updatedDate;

  ListingType(
    this.listingTypeID,
    this.parentID,
    this.typeName,
    this.typeNameEn,
    this.slug,
    this.deleted,
    this.createdDate,
    this.updatedDate,
  );

  factory ListingType.fromJson(Map<String, dynamic> json) => _$ListingTypeFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class PropertyTypeDraftListing {
  final int? id;
  final String? name;
  final int? propertyTypeGroupId;
  final String? portalCategory;
  final String? propertyTypeSlug;

  PropertyTypeDraftListing(
    this.id,
    this.name,
    this.propertyTypeGroupId,
    this.portalCategory,
    this.propertyTypeSlug,
  );

  factory PropertyTypeDraftListing.fromJson(Map<String, dynamic> json) =>
      _$PropertyTypeDraftListingFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class MediaListing {
  final int? id;
  final String? url;
  final int? sourceType;
  final bool? isDefault;
  final String? fileName;

  MediaListing(
    this.id,
    this.url,
    this.sourceType,
    this.isDefault,
    this.fileName,
  );

  factory MediaListing.fromJson(Map<String, dynamic> json) => _$MediaListingFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class LsoListingDraftPosition {
  final int? id;
  final int? positionId;
  final ListingAlley? alley;
  final double? roadFrontageDistanceFrom;
  final double? roadFrontageDistanceTo;
  final double? roadFrontageWidth;

  LsoListingDraftPosition(
    this.id,
    this.positionId,
    this.alley,
    this.roadFrontageDistanceFrom,
    this.roadFrontageDistanceTo,
    this.roadFrontageWidth,
  );

  factory LsoListingDraftPosition.fromJson(Map<String, dynamic> json) =>
      _$LsoListingDraftPositionFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class BuyPlan {
  final int? id;
  final BuyPlanOption? buyPlanOption;
  final District? district;
  final PropertyType? propertyType;
  final double? priceFrom;
  final double? priceTo;
  final String? slug;

  BuyPlan(
    this.id,
    this.buyPlanOption,
    this.district,
    this.propertyType,
    this.priceFrom,
    this.priceTo,
    this.slug,
  );

  factory BuyPlan.fromJson(Map<String, dynamic> json) => _$BuyPlanFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class BuyPlanOption {
  final int? id;

  BuyPlanOption(this.id);

  factory BuyPlanOption.fromJson(Map<String, dynamic> json) => _$BuyPlanOptionFromJson(json);
}
