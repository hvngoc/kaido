part of 'property_media_bloc.dart';

abstract class PropertyMediaEvent extends Equatable {
  const PropertyMediaEvent();
}

class PropertyMediaGetOfferEvent extends PropertyMediaEvent {
  final HomeOfferModel? offerModel;

  PropertyMediaGetOfferEvent(this.offerModel);

  @override
  List<Object?> get props => [offerModel];
}

class PropertyMediaCaptureImageEvent extends PropertyMediaEvent {
  final AssetEntity assetEntity;

  const PropertyMediaCaptureImageEvent(this.assetEntity);

  @override
  List<Object?> get props => [assetEntity];
}

class PropertyMediaSelectFromAlbumEvent extends PropertyMediaEvent {
  final List<AssetEntity>? pickedAssets;

  PropertyMediaSelectFromAlbumEvent(this.pickedAssets);

  @override
  List<Object?> get props => [pickedAssets];
}

class PropertyMediaUploadFilesEvent extends PropertyMediaEvent {
  @override
  List<Object?> get props => [];
}

class PropertyMediaDeleteFileEvent extends PropertyMediaEvent {
  final PropzyHomeMediaAssetModel assetModel;

  PropertyMediaDeleteFileEvent(this.assetModel);

  @override
  List<Object?> get props => [assetModel];
}

class PropertyMediaGetListCaptionEvent extends PropertyMediaEvent {
  @override
  List<Object?> get props => [];
}

class PropertyMediaSelectCaptionEvent extends PropertyMediaEvent {
  final PropzyHomeMediaAssetModel mediaAsset;
  final HomeCaptionMediaModel caption;

  PropertyMediaSelectCaptionEvent(this.mediaAsset, this.caption);

  @override
  List<Object?> get props => [mediaAsset, caption];
}

class PropertyMediaTimerEndEvent extends PropertyMediaEvent {
  @override
  List<Object?> get props => [];
}