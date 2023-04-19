import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    Key? key,
    required this.title,
    this.isEnabled = true,
    this.onPressed,
    this.defaultActiveColor,
    this.defaultTextColor,
    this.height = 50,
  }) : super(key: key);

  final String title;
  final bool isEnabled;
  final VoidCallback? onPressed;
  final Color? defaultActiveColor;
  final Color? defaultTextColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final activeColor = defaultActiveColor ?? AppColor.orangeDark;
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isEnabled ? activeColor : AppColor.gray500,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: defaultTextColor ?? Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class ReturnHomeButton extends StatelessWidget {
  const ReturnHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Container(
        height: 50,
        color: Colors.transparent,
        child: Center(
          child: Text(
            'Về trang chủ',
            style: TextStyle(
              color: AppColor.systemBlue,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class GreyButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const GreyButton({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.grayD5,
          borderRadius: BorderRadius.all(
            Radius.circular(
              4,
            ),
          ),
        ),
        height: 50,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
