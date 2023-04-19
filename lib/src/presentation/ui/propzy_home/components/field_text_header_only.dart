import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class FieldTextHeaderOnly extends StatelessWidget {
  final String title;
  final String images;

  const FieldTextHeaderOnly({
    Key? key,
    required this.title,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      child: Row(
        children: [
          SvgPicture.asset(images),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColor.blackDefault,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
