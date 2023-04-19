import 'package:json_annotation/json_annotation.dart';
import 'package:propzy_home/src/domain/model/owner_type_model.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/util/constants.dart';

part 'propzy_home_offer_model.g.dart';

@JsonSerializable(checked: true)
class HomeOfferModel {
  int? id;
  int? userId;
  int? stepId, reachedPageId, currentPage, ownerTypeId, propertyTypeId;
  int? directionId, certificateLandId;
  double? assignedTo;
  double? totalPercent;
  bool? unspecifiedLocation;
  HomePropertyTypeModel? propertyType;
  String? address;
  double? latitude, longitude;
  int? cityId, districtId, wardID, streetId, buildingId, blockBuildingId;
  String? houseNumber;
  double? length, width, lotSize, floorSize;
  int? numberFloor, bedroom, bathroom, livingRoom, kitchen;
  HomeIdNameModel? direction;
  HomeIdNameModel? houseShape;
  HomeIdNameModel? certificateLand;
  int? yearBuilt;
  HomeIdNameModel? expectedTime;
  int? facadeType;
  PropzyHomeFacadeContentRoad? facadeRoad;
  PropzyHomeFacadeContentAlley? facadeAlley;
  List<HomeHouseTexturesModel>? houseTextures;
  String? modelCode;
  String? buildingName, blockBuildingName;
  int? floorOrdinalNumber;
  HomeIdNameModel? mainDoorDirection, windowDirection;
  double? carpetArea, builtUpArea;
  HomeMeetingModel? meeting;
  String? suggestedPriceFormat, formatPrice, offeredPriceFormat;
  double? expectedPriceFrom, expectedPriceTo;
  String? contactName, contactPhone, contactEmail;
  PropzyHomeOfferPlanning? planning;
  List<HomeFileModel>? files;
  PropzyHomeStatusOffer? status;
  HomeActionCancelModel? actionCancel;
  int? suggestedPriceExpired;
  int? expectedTimeId;
  double? suggestedPrice;
  double? offeredPrice;
  PropertyInformation? propertyInfo;
  int? appointmentDate;
  int? mainDoorDirectionId;
  int? windowDirectionId;
  int? view;
  int? houseShapeId;
  OwnerType? ownerType;
  PropzyHomeReachedPage? reachedPage;

  HomeOfferModel({
    this.id,
    this.userId,
    this.unspecifiedLocation,
    this.totalPercent,
    this.propertyType,
    this.address,
    this.latitude,
    this.longitude,
    this.cityId,
    this.districtId,
    this.wardID,
    this.streetId,
    this.buildingId,
    this.blockBuildingId,
    this.houseNumber,
    this.length,
    this.width,
    this.lotSize,
    this.floorSize,
    this.numberFloor,
    this.bedroom,
    this.bathroom,
    this.livingRoom,
    this.kitchen,
    this.direction,
    this.certificateLand,
    this.yearBuilt,
    this.expectedTime,
    this.facadeType,
    this.facadeRoad,
    this.facadeAlley,
    this.houseTextures,
    this.modelCode,
    this.buildingName,
    this.blockBuildingName,
    this.floorOrdinalNumber,
    this.mainDoorDirection,
    this.windowDirection,
    this.carpetArea,
    this.builtUpArea,
    this.meeting,
    this.suggestedPriceFormat,
    this.formatPrice,
    this.offeredPriceFormat,
    this.expectedPriceFrom,
    this.expectedPriceTo,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.planning,
    this.status,
    this.actionCancel,
    this.suggestedPriceExpired,
    this.ownerType,
    this.reachedPage,
  });

  factory HomeOfferModel.fromJson(Map<String, dynamic> json) => _$HomeOfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeOfferModelToJson(this);

  bool propertyTypeIsApartment() {
    final id = propertyType?.id ?? 0;
    if (id == Constants.PROPERTY_TYPE_ID_APARTMENT) {
      return true;
    }
    return false;
  }
}

@JsonSerializable(checked: true)
class HomePropertyTypeModel {
  int? id;
  String? typeName;

  HomePropertyTypeModel({
    this.id,
    this.typeName,
  });

  factory HomePropertyTypeModel.fromJson(Map<String, dynamic> json) =>
      _$HomePropertyTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomePropertyTypeModelToJson(this);
}

@JsonSerializable(checked: true)
class HomeIdNameModel {
  int? id;
  String? name;

  HomeIdNameModel({
    this.id,
    this.name,
  });

  factory HomeIdNameModel.fromJson(Map<String, dynamic> json) => _$HomeIdNameModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeIdNameModelToJson(this);
}

@JsonSerializable(checked: true)
class HomeContiguousModel {
  int? id;
  int? facadeType;
  String? name;

  HomeContiguousModel({
    this.id,
    this.facadeType,
    this.name,
  });

  factory HomeContiguousModel.fromJson(Map<String, dynamic> json) =>
      _$HomeContiguousModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeContiguousModelToJson(this);
}

@JsonSerializable(checked: true)
class HomeHouseTexturesModel {
  int? id;
  int? parentId;
  String? name;

  HomeHouseTexturesModel({
    this.id,
    this.parentId,
    this.name,
  });

  factory HomeHouseTexturesModel.fromJson(Map<String, dynamic> json) =>
      _$HomeHouseTexturesModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeHouseTexturesModelToJson(this);
}

@JsonSerializable(checked: true)
class HomeMeetingModel {
  int? scheduleTime;

  HomeMeetingModel({
    this.scheduleTime,
  });

  factory HomeMeetingModel.fromJson(Map<String, dynamic> json) => _$HomeMeetingModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeMeetingModelToJson(this);
}

@JsonSerializable(checked: true)
class HomeScheduleOfferModel {
  int? offerId;
  String? scheduleTime;

  HomeScheduleOfferModel({
    this.offerId,
    this.scheduleTime,
  });

  factory HomeScheduleOfferModel.fromJson(Map<String, dynamic> json) =>
      _$HomeScheduleOfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeScheduleOfferModelToJson(this);
}

@JsonSerializable(checked: true)
class HomeFileModel {
  int? id, typeSource, typeFile;
  String? url, keyName;
  HomeCaptionMediaModel? caption;

  HomeFileModel({
    this.id,
    this.url,
    this.typeSource,
    this.typeFile,
    this.keyName,
    this.caption,
  });

  factory HomeFileModel.fromJson(Map<String, dynamic> json) => _$HomeFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFileModelToJson(this);
}

@JsonSerializable(checked: true)
class HomeCaptionMediaModel {
  int? id;
  String? name;
  int? type; // 1: hình nhà, 2: là pháp lý, 3: là video

  HomeCaptionMediaModel({
    this.id,
    this.name,
    this.type,
  });

  factory HomeCaptionMediaModel.fromJson(Map<String, dynamic> json) =>
      _$HomeCaptionMediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCaptionMediaModelToJson(this);
}

@JsonSerializable(checked: true)
class HomeProcessModel {
  String? name;
  bool? active;
  int? percent;
  String? processIcon, completedIcon;
  int? scheduleTime;

  HomeProcessModel({
    this.name,
    this.active,
    this.percent,
    this.processIcon,
    this.completedIcon,
    this.scheduleTime,
  });

  factory HomeProcessModel.fromJson(Map<String, dynamic> json) => _$HomeProcessModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeProcessModelToJson(this);
}

@JsonSerializable(checked: true)
class HomeActionCancelModel {
  String? reasonName;

  HomeActionCancelModel({
    this.reasonName,
  });

  factory HomeActionCancelModel.fromJson(Map<String, dynamic> json) =>
      _$HomeActionCancelModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeActionCancelModelToJson(this);
}

@JsonSerializable(checked: true)
class PropzyHomeCategoryOffer {
  PropzyHomeCategoryOffer({this.id, this.name, this.numberOffer, this.isChecked = false});

  int? id;
  String? name;
  int? numberOffer;
  bool? isChecked;


  factory PropzyHomeCategoryOffer.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeCategoryOfferFromJson(json);

}

@JsonSerializable(checked: true)
class PropzyHomeReachedPage {
  final int? pageId;
  final String? code;
  final String? title;
  final String? description;
  final String? content;
  final int? pageIndex;
  final String? pageValue;


  factory PropzyHomeReachedPage.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomeReachedPageFromJson(json);

  PropzyHomeReachedPage(this.pageId, this.code, this.title, this.description, this.content, this.pageIndex, this.pageValue);

}