import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/domain/request/propzy_home_create_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';

abstract class PropzyHomeEvent {}

class SaveDraftOfferEvent extends PropzyHomeEvent {
  final HomeOfferModel? draftOffer;

  SaveDraftOfferEvent(this.draftOffer);
}

class SavePropertyTypeSelectedEvent extends PropzyHomeEvent {
  final PropzyHomePropertyType propertyType;

  SavePropertyTypeSelectedEvent(this.propertyType);
}

class GetOfferDetailEvent extends PropzyHomeEvent {}

class ResetDraftOfferEvent extends PropzyHomeEvent {}

class CreateOfferEvent extends PropzyHomeEvent {
  final PropzyHomeCreateOfferRequest request;

  CreateOfferEvent(this.request);
}

class UpdateAlleyEvent extends PropzyHomeEvent {
  final int? reachedPageId;
  final double? alleyWidth;
  final double? distanceToRoad;
  final int? id;

  UpdateAlleyEvent({this.reachedPageId, this.alleyWidth, this.distanceToRoad, this.id});
}

class UpdateFacadeEvent extends PropzyHomeEvent {
  final int? reachedPageId;
  final double? roadWidth;
  final int? id;

  UpdateFacadeEvent({this.roadWidth, this.id, this.reachedPageId});
}

class UpdateOfferEvent extends PropzyHomeEvent {
  final int? reachedPageId;
  final List<int?>? listHomeTextureIds;
  final double? length;
  final double? width;
  final double? lotSize;
  final double? floorSize;
  final int? numberFloor;
  final double? latitude;
  final double? longitude;
  final int? directionId;
  final int? houseShapeId;
  final int? ownerTypeId;
  final int? cityId;
  final int? districtId;
  final int? wardID;
  final int? streetId;
  final int? blockBuildingId;
  final String? blockBuildingName;
  final int? buildingId;
  final String? buildingName;
  final int? propertyTypeId;

  final int? bedroom;
  final int? bathroom;
  final int? livingRoom;
  final int? kitchen;

  final String? modelCode;
  final String? address;
  final String? houseNumber;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final double? carpetArea;
  final double? builtUpArea;
  final int? floorOrdinalNumber;
  final int? mainDoorDirectionId;
  final int? windowDirectionId;
  final int? certificateLandId;
  final int? yearBuilt;
  final int? expectedTimeId;
  final double? expectedPriceFrom;
  final double? expectedPriceTo;
  final PropzyHomeOfferPlanning? planning;
  final bool? unspecifiedLocation;

  UpdateOfferEvent({
    this.reachedPageId,
    this.listHomeTextureIds,
    this.length,
    this.width,
    this.lotSize,
    this.floorSize,
    this.numberFloor,
    this.latitude,
    this.longitude,
    this.directionId,
    this.houseShapeId,
    this.modelCode,
    this.carpetArea,
    this.builtUpArea,
    this.floorOrdinalNumber,
    this.mainDoorDirectionId,
    this.windowDirectionId,
    this.bedroom,
    this.bathroom,
    this.livingRoom,
    this.kitchen,
    this.certificateLandId,
    this.yearBuilt,
    this.expectedTimeId,
    this.expectedPriceFrom,
    this.expectedPriceTo,
    this.planning,
    this.ownerTypeId,
    this.cityId,
    this.districtId,
    this.address,
    this.wardID,
    this.streetId,
    this.houseNumber,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.unspecifiedLocation,
    this.blockBuildingId,
    this.blockBuildingName,
    this.buildingId,
    this.buildingName,
    this.propertyTypeId,
  });
}
