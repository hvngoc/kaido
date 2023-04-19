import 'package:propzy_home/src/domain/model/common_model.dart';
import 'package:propzy_home/src/domain/model/common_model_1.dart';
import 'package:propzy_home/src/domain/model/property_type_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/util/constants.dart';

class CategorySearchRequest {
  ///1 mua, 2 thue
  int listingTypeId;
  CategoryType categoryType;

  String? sortBy;
  String? sortDirection;
  int? size;
  int? page;

  double? lat;
  double? lng;

  List<int>? cityIds;
  List<int>? districtIds;
  List<int>? wardIds;
  List<int>? streetIds;

  List<PropertyType?>? propertyTypeIds;
  List<Direction?>? directionIds;
  List<Advantage?>? advantageIds;
  List<Amenity?>? amenityIds;
  BedRoom? bedrooms;
  BathRoom? bathrooms;
  Content? contentId;
  Position? propertyPosition;

  double? minPrice;
  double? maxPrice;
  double? minSize;
  double? maxSize;
  int? minYear;
  int? maxYear;
  List<int>? statusIds;

  CategorySearchRequest({
    this.listingTypeId = 1,
    required this.categoryType,
    this.sortBy,
    this.sortDirection,
    this.size = 10,
    this.page = 0,
    this.lat,
    this.lng,
    this.cityIds,
    this.districtIds,
    this.wardIds,
    this.streetIds,

    //
    this.propertyTypeIds,
    this.bedrooms,
    this.bathrooms,
    this.contentId,
    this.propertyPosition,
    this.directionIds,
    this.advantageIds,
    this.amenityIds,
    this.minPrice,
    this.maxPrice,
    this.minSize,
    this.maxSize,
    this.minYear,
    this.maxYear,
    this.statusIds,
  });

  CategorySearchRequest clone() {
    return CategorySearchRequest(
      listingTypeId: this.listingTypeId,
      categoryType: this.categoryType,
      sortBy: this.sortBy,
      sortDirection: this.sortDirection,
      size: this.size,
      page: this.page,
      lat: this.lat,
      lng: this.lng,
      cityIds: this.cityIds,
      districtIds: this.districtIds,
      wardIds: this.wardIds,
      streetIds: this.streetIds,
      propertyTypeIds: this.propertyTypeIds,
      directionIds: this.directionIds,
      advantageIds: this.advantageIds,
      amenityIds: this.amenityIds,
      bedrooms: this.bedrooms,
      bathrooms: this.bathrooms,
      contentId: this.contentId,
      propertyPosition: this.propertyPosition,
      minPrice: this.minPrice,
      maxPrice: this.maxPrice,
      minSize: this.minSize,
      maxSize: this.maxSize,
      minYear: this.minYear,
      maxYear: this.maxYear,
      statusIds: this.statusIds,
    );
  }

  CategorySearchRequest copyWith({
    int? listingTypeId,
    CategoryType? categoryType,
    String? sortBy,
    String? sortDirection,
    int? size,
    int? page,
    double? lat,
    double? lng,
    List<int>? cityIds,
    List<int>? districtIds,
    List<int>? wardIds,
    List<int>? streetIds,
    List<PropertyType?>? propertyTypeIds,
    List<Direction?>? directionIds,
    List<Advantage?>? advantageIds,
    List<Amenity?>? amenityIds,
    BedRoom? bedrooms,
    BathRoom? bathrooms,
    Content? contentId,
    Position? propertyPosition,
    double? minPrice,
    double? maxPrice,
    double? minSize,
    double? maxSize,
    int? minYear,
    int? maxYear,
    List<int>? statusIds,
  }) {
    return CategorySearchRequest(
      listingTypeId: listingTypeId ?? this.listingTypeId,
      categoryType: categoryType ?? this.categoryType,
      size: size ?? this.size,
      page: page ?? this.page,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      lat: lat,
      lng: lng,
      cityIds: cityIds,
      districtIds: districtIds,
      wardIds: wardIds,
      streetIds: streetIds,
      propertyTypeIds: propertyTypeIds == null ? this.propertyTypeIds : (propertyTypeIds.isEmpty == true ? null : propertyTypeIds),
      bedrooms: (bedrooms == BedRoom.ALL) ? null : bedrooms ?? this.bedrooms,
      bathrooms: (bathrooms == BathRoom.ALL) ? null : bathrooms ?? this.bathrooms,
      contentId: (contentId == Content.ALL) ? null : contentId ?? this.contentId,
      propertyPosition: (propertyPosition == Position.ALL) ? null : propertyPosition ?? this.propertyPosition,
      directionIds: directionIds == null ? this.directionIds : (directionIds.isEmpty == true ? null : directionIds),
      advantageIds: advantageIds == null ? this.advantageIds : (advantageIds.isEmpty == true ? null : advantageIds),
      amenityIds: amenityIds == null ? this.amenityIds : (amenityIds.isEmpty == true ? null : amenityIds),
      minPrice: (minPrice == -1.0) ? null : minPrice ?? this.minPrice,
      maxPrice: (maxPrice == -1.0) ? null : maxPrice ?? this.maxPrice,
      minSize: (minSize == -1.0) ? null : minSize ?? this.minSize,
      maxSize: (maxSize == -1.0) ? null : maxSize ?? this.maxSize,
      minYear: (minYear == -1) ? null : minYear ?? this.minYear,
      maxYear: (maxYear == -1) ? null : maxYear ?? this.maxYear,
      statusIds: statusIds == null ? this.statusIds : (statusIds.isEmpty == true ? null : statusIds),
    );
  }

  CategorySearchRequest resetFilter({
    int? listingTypeId,
    CategoryType? categoryType,
  }) {
    final newType = categoryType ?? this.categoryType;
    return CategorySearchRequest(
      listingTypeId: listingTypeId ?? this.listingTypeId,
      categoryType: newType,
      size: size,
      page: page,
      sortBy: sortBy,
      sortDirection: sortDirection,
      lat: lat,
      lng: lng,
      cityIds: cityIds,
      districtIds: districtIds,
      wardIds: wardIds,
      streetIds: streetIds,
      propertyTypeIds: null,
      bedrooms: null,
      bathrooms: null,
      contentId: null,
      propertyPosition: null,
      directionIds: null,
      advantageIds: null,
      amenityIds: null,
      minPrice: null,
      maxPrice: null,
      minSize: null,
      maxSize: null,
      minYear: null,
      maxYear: null,
      statusIds: newType == CategoryType.PROJECT ? null : [Constants.CATEGORY_FILTER_STATUS_LIVE],
    );
  }

  bool isFiltering() {
    final advantage = advantageIds?.isNotEmpty == true;
    final amenity = amenityIds?.isNotEmpty == true;
    final direction = directionIds?.isNotEmpty == true;
    final propertyType = propertyTypeIds?.isNotEmpty == true;
    final bed = bedrooms != null;
    final bath = bedrooms != null;
    final content = contentId != null;
    final properties = propertyPosition != null;
    final priceMin = minPrice != null;
    final priceMax = maxPrice != null;
    final sizeMin = minSize != null;
    final sizeMax = maxSize != null;
    final yearMin = minYear != null;
    final yearMax = maxYear != null;
    final status =
        statusIds?.isNotEmpty == true && statusIds?.first != Constants.CATEGORY_FILTER_STATUS_LIVE;
    return advantage ||
        amenity ||
        direction ||
        propertyType ||
        bed ||
        bath ||
        content ||
        properties ||
        priceMin ||
        priceMax ||
        sizeMin ||
        sizeMax ||
        yearMax ||
        yearMin ||
        status;
  }
}
