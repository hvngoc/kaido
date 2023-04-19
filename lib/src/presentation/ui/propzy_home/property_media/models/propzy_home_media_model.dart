import 'package:equatable/equatable.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PropzyHomeMediaAssetModel extends Equatable {
  HomeFileModel? file;
  AssetEntity? assetEntity;
  int typeSource;
  int typeFile;
  HomeCaptionMediaModel? caption;
  bool isUploadSuccess;
  bool isChangeCaption;

  PropzyHomeMediaAssetModel({
    this.file,
    this.assetEntity,
    this.typeSource = 1,
    this.typeFile = 1,
    this.caption,
    this.isUploadSuccess = false,
    this.isChangeCaption = false,
  });

  bool get isNull => file == null && assetEntity == null;

  bool get isFileModel => file != null;

  bool get isAssetEntity => assetEntity != null;

  // String get captionName =>
  //     isAssetEntity ? (caption?.name ?? 'Chọn ghi chú ...') : (caption?.name ?? 'Khác');
  String get captionName => caption?.name ?? 'Chọn ghi chú ...';

  bool get isSelectCaption => captionName == 'Chọn ghi chú ...';

  @override
  List<Object?> get props => [file, assetEntity, typeSource, typeFile];
}
