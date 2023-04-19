import 'package:json_annotation/json_annotation.dart';
import 'package:propzy_home/src/domain/model/listing_location.dart';
import 'package:propzy_home/src/domain/model/listing_photo.dart';

part 'category_home_listing.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class CategoryHomeListing {
  int id = 0;
  String? title;
  int? bathrooms;
  int? bedrooms;
  double? unitPrice;
  double? priceVND;
  int? wardId;
  String? wardName;
  String? wardSlug;
  int? districtId;
  String? districtName;
  String? districtSlug;
  int? streetId;
  String? streetName;
  String? streetSlug;
  int? cityId;
  String? cityName;
  String? citySlug;
  int? propertyTypeId;
  String? propertyTypeName;
  String? propertyTypeSlug;
  int? listingTypeId;
  String? listingTypeName;
  String? listingTypeSlug;
  double? size;
  int? projectId;
  String? projectName;
  String? directionName;
  String? labelCode;
  String? labelName;
  int? liveType;
  String? priceTrend;
  String? tradedStatus;
  String? formattedPriceVnd;
  String? formattedUnitPrice;
  String? formattedSize;
  List<ListingPhoto>? thumbnails;
  int? statusDate;
  int? statusId;
  bool? useDefaultPhoto;
  int? classify;
  Location? location;

  CategoryHomeListing(
      this.id,
      this.title,
      this.bathrooms,
      this.bedrooms,
      this.unitPrice,
      this.priceVND,
      this.wardId,
      this.wardName,
      this.wardSlug,
      this.districtId,
      this.districtName,
      this.districtSlug,
      this.streetId,
      this.streetName,
      this.streetSlug,
      this.cityId,
      this.cityName,
      this.citySlug,
      this.propertyTypeId,
      this.propertyTypeName,
      this.propertyTypeSlug,
      this.listingTypeId,
      this.listingTypeName,
      this.listingTypeSlug,
      this.size,
      this.projectId,
      this.projectName,
      this.directionName,
      this.labelCode,
      this.labelName,
      this.liveType,
      this.tradedStatus,
      this.formattedPriceVnd,
      this.formattedUnitPrice,
      this.formattedSize,
      this.thumbnails,
      this.statusDate,
      this.statusId,
      this.useDefaultPhoto,
      this.classify,
      this.location);

  String getAddress() {
    List list = [streetName, wardName, districtName, cityName];
    list.removeWhere((element) => element == null);
    return list.join(", ");
  }

  factory CategoryHomeListing.fromJson(Map<String, dynamic> json) => _$CategoryHomeListingFromJson(json);

}
