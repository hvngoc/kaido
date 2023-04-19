import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({
    Key? key,
    required this.iconName,
    required this.title,
    required this.onTapAction,
  }) : super(key: key);

  final String iconName;
  final String title;
  final Function(BuildContext) onTapAction;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTapAction(context);
        },
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: DottedDecoration(
            shape: Shape.box,
            borderRadius: BorderRadius.circular(4),
            color: AppColor.propzyBlue100,
            strokeWidth: 2,
          ),
          child: Container(
            color: AppColor.grayF4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconName,
                  width: 32,
                  height: 32,
                ),
                SizedBox(height: 4),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
