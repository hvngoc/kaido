import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class FieldTextDropDown extends StatelessWidget {
  final String title;
  final double childWidth;

  final String? value;
  final GestureTapCallback? onTap;

  const FieldTextDropDown({
    Key? key,
    required this.title,
    required this.childWidth,
    this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppColor.blackDefault,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: 8),
          Material(
            color: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: BorderSide(
                width: 1,
                color: AppColor.grayC6,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 48,
                width: childWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          value ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.secondaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor.gray7D,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
