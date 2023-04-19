import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_media/bloc/choose_media_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_media/models/listing_media_asset_model.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:extended_image/extended_image.dart';

class ListingAssetPreviewItem extends StatelessWidget {
  const ListingAssetPreviewItem({
    Key? key,
    required this.mediaAsset,
    required this.onTapCallback,
    required this.isMedia,
  }) : super(key: key);

  final ListingMediaAssetModel mediaAsset;
  final GestureTapCallback onTapCallback;
  final bool isMedia;

  @override
  Widget build(BuildContext context) {
    final fileUrl = mediaAsset.mediaListing?.url ?? '';
    return Container(
      height: 100,
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
                if (mediaAsset.isMediaListing && fileUrl.isNotEmpty)
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.network(
                          fileUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, _) => Image(
                            image: AssetImage('assets/images/ic_default_image_listing.png'),
                            fit: BoxFit.cover,
                          ),
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
                          .read<ChooseMediaBloc>()
                          .add(ChooseMediaDeleteFileEvent(mediaAsset, isMedia));
                    },
                    child: SvgPicture.asset(
                      'assets/images/ic_close_white.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                // Visibility(
                //   visible: mediaAsset.typeFile == 2,
                //   child: InkWell(
                //     onTap: () {},
                //     child: SvgPicture.asset(
                //       'assets/images/ic_button_play.svg',
                //       width: 40,
                //       height: 40,
                //     ),
                //   ),
                // ),
                Visibility(
                  visible: mediaAsset.typeSource == Constants.MEDIA_SOURCE_TYPE_MEDIA &&
                      mediaAsset.typeFile == Constants.MEDIA_FILE_TYPE_IMAGE,
                  child: Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        onTapCallback();
                      },
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              mediaAsset.isDefault
                                  ? 'assets/images/ic_check_circle_fill.svg'
                                  : 'assets/images/ic_check_circle.svg',
                              width: 18,
                              height: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Hình mặc định',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
