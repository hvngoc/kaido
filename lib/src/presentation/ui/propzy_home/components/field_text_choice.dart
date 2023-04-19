import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class FieldTextChoice extends StatelessWidget {
  final bool isChecked;
  final GestureTapCallback? onTap;
  final String title;
  final TextStyle? style;

  const FieldTextChoice({
    Key? key,
    required this.isChecked,
    this.onTap,
    required this.title,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isChecked ? AppColor.propzyBlue_100 : AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(
          width: 1,
          color: isChecked ? AppColor.systemBlue : AppColor.gray400,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 54,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SvgPicture.asset(isChecked
                  ? "assets/images/vector_ic_type_properties_checked.svg"
                  : "assets/images/vector_ic_type_properties_normal.svg"),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style ??
                      TextStyle(
                        color: AppColor.blackDefault,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
