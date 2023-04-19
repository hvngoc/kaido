import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_style.dart';

class LabelText extends StatelessWidget {
  const LabelText({Key? key, this.label}) : super(key: key);
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label ?? '',
      style: BigRevampStyle.labelTextStyle,
    );
  }
}
