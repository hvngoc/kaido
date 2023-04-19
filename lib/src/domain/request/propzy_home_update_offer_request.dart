import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_update_offer_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeUpdateOfferRequest {
  int? id;
  int? stepId;
  int? reachedPageId;
  int? currentPage;
  PropzyHomeStatusOffer? status;
  int? ownerTypeId;
  double? assignedTo;
  int? propertyTypeId;
  String? address;
  double? latitude;
  double? longitude;
  int? cityId;
  int? districtId;
  int? wardID;
  int? streetId;
  int? userId;
  String? houseNumber;
  double? length;
  double? width;
  double? lotSize;
  double? floorSize;
  int? numberFloor;
  int? bathroom;
  int? bedroom;
  int? kitchen;
  int? livingRoom;
  int? directionId;
  int? certificateLandId;
  int? yearBuilt;
  int? facadeType;
  int? expectedTimeId;
  double? expectedPriceFrom;
  double? expectedPriceTo;
  double? suggestedPrice;
  double? offeredPrice;
  String? contactName;
  String? contactPhone;
  String? contactEmail;
  PropzyHomeOfferPlanning? planning;
  PropzyHomeFacadeContentAlley? facadeAlley;
  PropzyHomeFacadeContentRoad? facadeRoad;
  List<int?>? houseTexturesIds;
  PropertyInformation? propertyInfo;
  bool? unspecifiedLocation;
  int? appointmentDate;
  String? modelCode;
  double? carpetArea;
  double? builtUpArea;
  int? floorOrdinalNumber;
  int? mainDoorDirectionId;
  int? windowDirectionId;
  int? view;
  int? buildingId;
  String? buildingName;
  int? blockBuildingId;
  String? blockBuildingName;
  int? houseShapeId;

  factory PropzyHomeUpdateOfferRequest.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeUpdateOfferRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeUpdateOfferRequestToJson(this);

  PropzyHomeUpdateOfferRequest({
    this.id,
    this.stepId,
    this.reachedPageId,
    this.currentPage,
    this.status,
    this.ownerTypeId,
    this.assignedTo,
    this.propertyTypeId,
    this.address,
    this.latitude,
    this.longitude,
    this.cityId,
    this.districtId,
    this.wardID,
    this.streetId,
    this.userId,
    this.houseNumber,
    this.length,
    this.width,
    this.lotSize,
    this.floorSize,
    this.numberFloor,
    this.bathroom,
    this.bedroom,
    this.kitchen,
    this.livingRoom,
    this.directionId,
    this.certificateLandId,
    this.yearBuilt,
    this.facadeType,
    this.expectedTimeId,
    this.expectedPriceFrom,
    this.expectedPriceTo,
    this.suggestedPrice,
    this.offeredPrice,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.planning,
    this.facadeAlley,
    this.facadeRoad,
    this.houseTexturesIds,
    this.propertyInfo,
    this.unspecifiedLocation,
    this.appointmentDate,
    this.modelCode,
    this.carpetArea,
    this.builtUpArea,
    this.floorOrdinalNumber,
    this.mainDoorDirectionId,
    this.windowDirectionId,
    this.view,
    this.buildingId,
    this.buildingName,
    this.blockBuildingId,
    this.blockBuildingName,
    this.houseShapeId,
  });
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeStatusOffer {
  int? id;
  String? name;
  PropzyHomeProcessOffer? process;
  List<PropzyHomeOfferCategory>? categories;

  PropzyHomeStatusOffer({this.id, this.name, this.process, this.categories});

  factory PropzyHomeStatusOffer.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeStatusOfferFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeStatusOfferToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeProcessOffer {
  int? id;
  String? name;
  String? completedIcon;
  String? processIcon;
  int? createdBy;
  String? createdDate;
  double? displayOrder;
  double? percent;
  List<PropzyHomeStatus>? status;
  bool? active;
  int? scheduleTime;

  PropzyHomeProcessOffer({
    this.id,
    this.name,
    this.completedIcon,
    this.processIcon,
    this.createdBy,
    this.createdDate,
    this.displayOrder,
    this.percent,
    this.status,
    this.active,
    this.scheduleTime,
  });

  factory PropzyHomeProcessOffer.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeProcessOfferFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeProcessOfferToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeOfferCategory {
  int? id;
  String? name;
  int? createdBy;
  String? createdDate;
  double? displayOrder;
  bool? isActive;
  List<PropzyHomeStatus>? statuses;

  PropzyHomeOfferCategory({
    this.id,
    this.name,
    this.createdBy,
    this.createdDate,
    this.displayOrder,
    this.isActive,
    this.statuses,
  });

  factory PropzyHomeOfferCategory.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeOfferCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeOfferCategoryToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeOfferPlanning {
  int? planningToBuy;
  int? propertyTypeId;
  double? priceFrom;
  double? priceTo;
  List<PropzyHomeOfferCity>? cities;
  List<PropzyHomeOfferDistrict>? districts;
  List<PropzyHomeOfferWard>? wards;

  PropzyHomeOfferPlanning({
    this.planningToBuy,
    this.propertyTypeId,
    this.priceFrom,
    this.priceTo,
    this.cities,
    this.districts,
    this.wards,
  });

  factory PropzyHomeOfferPlanning.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeOfferPlanningFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeOfferPlanningToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeFacadeContentContiguous {
  int? facadeType;
  int? id;
  String? name;

  PropzyHomeFacadeContentContiguous({
    this.facadeType,
    this.id,
    this.name,
  });

  factory PropzyHomeFacadeContentContiguous.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeFacadeContentContiguousFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeFacadeContentContiguousToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeFacadeContent {
  int? id;
  PropzyHomeFacadeContentContiguous? contiguous;

  PropzyHomeFacadeContent({
    this.id,
    this.contiguous,
  });

  factory PropzyHomeFacadeContent.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeFacadeContentFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeFacadeContentToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeFacadeContentRoad extends PropzyHomeFacadeContent {
  double? roadWidth;
  int? contiguousId;

  PropzyHomeFacadeContentRoad({
    this.roadWidth,
    this.contiguousId,
  });

  updateContiguousId() {
    contiguousId = contiguous?.id;
  }

  factory PropzyHomeFacadeContentRoad.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeFacadeContentRoadFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeFacadeContentRoadToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeFacadeContentAlley extends PropzyHomeFacadeContent {
  int? contiguousId;
  double? distanceToRoad;
  double? alleyWidth;

  PropzyHomeFacadeContentAlley({
    this.contiguousId,
    this.distanceToRoad,
    this.alleyWidth,
  });

  updateContiguousId() {
    contiguousId = contiguous?.id;
  }

  factory PropzyHomeFacadeContentAlley.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeFacadeContentAlleyFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeFacadeContentAlleyToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropertyInformation {
  String? address;
  int? city_id;
  int? district_id;
  int? ward_id;
  int? street_id;
  bool? unspecifiedLocation;
  int? blockBuildingId;
  String? blockBuildingName;
  int? buildingId;
  String? buildingName;

  PropertyInformation({
    this.address,
    this.city_id,
    this.district_id,
    this.ward_id,
    this.street_id,
    this.unspecifiedLocation,
    this.blockBuildingId,
    this.blockBuildingName,
    this.buildingId,
    this.buildingName,
  });

  factory PropertyInformation.fromJson(Map<String, dynamic> json) =>
      _$PropertyInformationFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyInformationToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeStatus {
  String? createdDate;
  double? displayOrder;
  int? id;
  int? processId;
  int? statusId;
  String? updatedDate;

  PropzyHomeStatus({
    this.createdDate,
    this.displayOrder,
    this.id,
    this.processId,
    this.statusId,
    this.updatedDate,
  });

  factory PropzyHomeStatus.fromJson(Map<String, dynamic> json) => _$PropzyHomeStatusFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeStatusToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeOfferCity {
  int? cityId;
  int? id;
  bool? preferred;

  PropzyHomeOfferCity({
    this.cityId,
    this.id,
    this.preferred,
  });

  factory PropzyHomeOfferCity.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeOfferCityFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeOfferCityToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeOfferDistrict {
  int? districtId;
  int? cityId;
  int? id;
  bool? preferred;

  PropzyHomeOfferDistrict({
    this.districtId,
    this.cityId,
    this.id,
    this.preferred,
  });

  factory PropzyHomeOfferDistrict.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeOfferDistrictFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeOfferDistrictToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeOfferWard {
  int? wardId;
  int? districtId;
  int? id;
  bool? preferred;

  PropzyHomeOfferWard({
    this.wardId,
    this.districtId,
    this.id,
    this.preferred,
  });

  factory PropzyHomeOfferWard.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeOfferWardFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeOfferWardToJson(this);
}

@JsonSerializable(checked: true, createToJson: true)
class PropzyHomeUpdateCaptionRequest {
  int id;
  int captionId;

  PropzyHomeUpdateCaptionRequest({
    required this.id,
    required this.captionId,
  });

  factory PropzyHomeUpdateCaptionRequest.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeUpdateCaptionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeUpdateCaptionRequestToJson(this);
}