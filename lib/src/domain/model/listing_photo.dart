import 'package:json_annotation/json_annotation.dart';

part 'listing_photo.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class ListingPhoto {
  String? link;
  String? source;
  bool? isPrivate;
  bool? isApproved;
  bool? isNew;
  bool? isDeleted;
  String? thumb887x500Link;
  String? thumb500x375Link;
  String? thumb375x250Link;
  bool? isSellerNew;

  ListingPhoto(this.link, this.source, this.isPrivate, this.isApproved, this.isNew, this.isDeleted,
      this.thumb887x500Link, this.thumb500x375Link, this.thumb375x250Link, this.isSellerNew);

  factory ListingPhoto.fromJson(Map<String, dynamic> json) => _$ListingPhotoFromJson(json);
}

@JsonSerializable(createToJson: false, checked: true)
class ListingLinkMedia {
  String? link;
  String? file_name;

  ListingLinkMedia({
    this.link,
    this.file_name,
  });

  factory ListingLinkMedia.fromJson(Map<String, dynamic> json) => _$ListingLinkMediaFromJson(json);
}