import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/bloc/property_media_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/models/propzy_home_media_model.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:extended_image/extended_image.dart';

class AssetPreviewItem extends StatelessWidget {
  const AssetPreviewItem({
    Key? key,
    required this.mediaAsset,
    required this.onTapCallback,
  }) : super(key: key);

  final PropzyHomeMediaAssetModel mediaAsset;
  final GestureTapCallback onTapCallback;

  @override
  Widget build(BuildContext context) {
    final fileUrl = mediaAsset.file?.url ?? '';
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (mediaAsset.isAssetEntity)
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: ExtendedImage(
                        width: double.infinity,
                        height: double.infinity,
                        image: AssetEntityImageProvider(mediaAsset.assetEntity!, isOriginal: false),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (mediaAsset.isFileModel)
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.network(
                          fileUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () {
                      context
                          .read<PropertyMediaBloc>()
                          .add(PropertyMediaDeleteFileEvent(mediaAsset));
                    },
                    child: SvgPicture.asset(
                      'assets/images/ic_button_close.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
                Visibility(
                  visible: mediaAsset.typeFile == 2,
                  child: InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/images/ic_button_play.svg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(width: 1, color: AppColor.grayD8),
            ),
            child: InkWell(
              onTap: () {
                onTapCallback();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        mediaAsset.captionName,
                        style: TextStyle(
                          color: mediaAsset.isSelectCaption ? AppColor.grayCC : Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  VerticalDivider(width: 1, color: AppColor.grayD8),
                  Container(
                    width: 40,
                    child: SvgPicture.asset(
                      'assets/images/ic_arrow_down_black.svg',
                      height: 18,
                      width: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
