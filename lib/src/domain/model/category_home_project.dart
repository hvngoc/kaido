import 'package:json_annotation/json_annotation.dart';
import 'package:propzy_home/src/domain/model/listing_photo.dart';

part 'category_home_project.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class CategoryHomeProject {
  int id = 0;
  String? projectName;
  String? address;
  String? investorName;
  String? price;
  int? statusId;
  String? statusName;
  List<String>? listingTypeIds;
  int? numberOfLiveListingForRent;
  int? numberOfLiveListingForSale;
  List<ListingPhoto>? thumbnails;
  int? yearBuilt;
  double? minPriceOfLiveListingRent;
  double? maxPriceOfLiveListingRent;
  double? minPriceOfLiveListingSale;
  double? maxPriceOfLiveListingSale;
  String? formattedMinPriceOfLiveListingRent;
  String? formattedMaxPriceOfLiveListingRent;
  String? formattedMinPriceOfLiveListingSale;
  String? formattedMaxPriceOfLiveListingSale;
  String? slug;

  CategoryHomeProject(
      this.id,
      this.projectName,
      this.address,
      this.investorName,
      this.price,
      this.statusId,
      this.statusName,
      this.listingTypeIds,
      this.numberOfLiveListingForRent,
      this.numberOfLiveListingForSale,
      this.thumbnails,
      this.yearBuilt,
      this.minPriceOfLiveListingRent,
      this.maxPriceOfLiveListingRent,
      this.minPriceOfLiveListingSale,
      this.maxPriceOfLiveListingSale,
      this.formattedMinPriceOfLiveListingRent,
      this.formattedMaxPriceOfLiveListingRent,
      this.formattedMinPriceOfLiveListingSale,
      this.formattedMaxPriceOfLiveListingSale,
      this.slug);

  factory CategoryHomeProject.fromJson(Map<String, dynamic> json) => _$CategoryHomeProjectFromJson(json);
}


