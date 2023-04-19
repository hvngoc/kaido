import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:string_validator/string_validator.dart';

class ImageThumbnailView extends StatelessWidget {
  const ImageThumbnailView({
    Key? key,
    this.fileUrl,
    this.boxFit = BoxFit.cover,
    this.errImage,
    this.onClick,
    this.progressColor,
  }) : super(key: key);

  final String? fileUrl;
  final BoxFit? boxFit;
  final String? errImage;
  final GestureTapCallback? onClick;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    String? imageUrlMake = fileUrl?._makeHttps();

    return InkWell(
      onTap: onClick,
      child: CachedNetworkImage(
        imageUrl: imageUrlMake ?? '',
        fit: boxFit,
        placeholder: (context, url) => Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: progressColor ?? AppColor.orangeDark,
            ),
          ),
        ),
        imageBuilder: (context, image) => Image(
          image: image,
          fit: boxFit,
        ),
        errorWidget: (context, url, error) {
          if (errImage != null) {
            return Image.asset(
              errImage ?? 'assets/images/ic_default_image_listing.png',
              fit: boxFit,
            );
          }
          return Icon(
            Icons.error_outline,
            color: AppColor.red,
          );
        },
      ),
    );
  }
}

extension on String {
  String _makeHttps() {
    if (!isURL(this) || this.contains('https')) {
      return this;
    }
    return replaceAll('http', 'https');
  }
}
