part of 'choose_media_bloc.dart';

abstract class ChooseMediaEvent extends Equatable {
  const ChooseMediaEvent();
}

class ChooseMediaCaptureImageEvent extends ChooseMediaEvent {
  final AssetEntity assetEntity;
  final bool isMedia;

  const ChooseMediaCaptureImageEvent(this.assetEntity, this.isMedia);

  @override
  List<Object?> get props => [assetEntity, isMedia];
}

class ChooseMediaSelectFromAlbumEvent extends ChooseMediaEvent {
  final List<AssetEntity>? pickedAssets;
  final bool isMedia;

  ChooseMediaSelectFromAlbumEvent(this.pickedAssets, this.isMedia);

  @override
  List<Object?> get props => [pickedAssets, isMedia];
}

class ChooseMediaDeleteFileEvent extends ChooseMediaEvent {
  final ListingMediaAssetModel assetModel;
  final bool isMedia;

  ChooseMediaDeleteFileEvent(this.assetModel, this.isMedia);

  @override
  List<Object?> get props => [assetModel, isMedia];
}

class ChooseMediaSetDefaultEvent extends ChooseMediaEvent {
  final ListingMediaAssetModel assetModel;
  final bool isMedia;

  ChooseMediaSetDefaultEvent(this.assetModel, this.isMedia);

  @override
  List<Object?> get props => [assetModel, isMedia];
}

class UploadImageEvent extends ChooseMediaEvent {
  @override
  List<Object?> get props => [];
}

class ChooseMediaTimerEndEvent extends ChooseMediaEvent {
  @override
  List<Object?> get props => [];
}

class ChooseMediaLoadDataEvent extends ChooseMediaEvent {
  final List<MediaListing>? listMediaListing;

  ChooseMediaLoadDataEvent(this.listMediaListing);

  @override
  List<Object?> get props => [listMediaListing];
}