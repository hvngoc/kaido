import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class FieldTextDropNoTitle extends StatelessWidget {
  final String? title;
  final String? hint;

  final GestureTapCallback? onTap;

  final TextStyle? style;
  final TextStyle? hintStyle;

  const FieldTextDropNoTitle({
    Key? key,
    this.title,
    this.hint,
    this.onTap,
    this.style,
    this.hintStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle _style = style ?? TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColor.blackDefault,
    );

    final TextStyle _hintStyle = hintStyle ?? TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColor.secondaryText,
    );

    return Material(
      color: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(
          width: 1,
          color: AppColor.grayBorderDE,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Text(
                title ?? hint ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: title != null ? _style : _hintStyle,
              ),
              Spacer(),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColor.grayC6,
                size: 20,
              ),
              SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
