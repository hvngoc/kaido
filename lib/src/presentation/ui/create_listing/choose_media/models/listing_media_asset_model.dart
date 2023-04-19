import 'package:equatable/equatable.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ListingMediaAssetModel extends Equatable {
  MediaListing? mediaListing;
  AssetEntity? assetEntity;
  int typeSource;
  int typeFile;
  bool isDefault;
  bool isUploadSuccess;

  ListingMediaAssetModel({
    this.mediaListing,
    this.assetEntity,
    this.typeSource = 1,
    this.typeFile = 1,
    this.isDefault = false,
    this.isUploadSuccess = false,
  });

  bool get isNull => mediaListing == null && assetEntity == null;

  bool get isMediaListing => mediaListing != null;

  bool get isAssetEntity => assetEntity != null;

  @override
  List<Object?> get props => [mediaListing, assetEntity, typeSource, typeFile, isDefault];
}
