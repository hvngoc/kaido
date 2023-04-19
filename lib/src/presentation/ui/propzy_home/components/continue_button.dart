import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class PropzyHomeContinueButton extends StatelessWidget {
  final bool isEnable;
  final double? height;
  final double? width;
  final String? content;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Function? onClick;
  final FontWeight? fontWeight;

  const PropzyHomeContinueButton({
    Key? key,
    required this.isEnable,
    this.onClick,
    this.height,
    this.width,
    this.content,
    this.padding,
    this.margin,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48,
      width: width ?? double.infinity,
      margin: margin ?? EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isEnable ? AppColor.orangeDark : HexColor("ADB5BD"),
      ),
      child: InkWell(
        onTap: () {
          if (isEnable) {
            onClick?.call();
          }
        },
        child: Center(
          child: Text(
            content ?? "Tiếp tục",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontWeight: fontWeight ?? FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
