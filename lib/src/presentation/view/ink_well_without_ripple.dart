import 'package:flutter/material.dart';

class InkWellWithoutRipple extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;

  const InkWellWithoutRipple({Key? key, required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: InkWell(
          child: child,
          onTap: onTap,
        ));
  }
}
