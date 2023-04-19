import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class ExpandSingleCustom extends StatelessWidget {
  final bool isChecked;
  final String name;
  final List<Widget> listCustom;
  final GestureTapCallback onSectionTap;

  const ExpandSingleCustom({
    Key? key,
    required this.isChecked,
    required this.name,
    required this.listCustom,
    required this.onSectionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColor.grayE4),
        boxShadow: [
          BoxShadow(
            color: AppColor.grayF4,
            blurRadius: 2,
            offset: Offset(2, 2),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: AppColor.grayF9,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: InkWell(
              onTap: onSectionTap,
              child: Container(
                height: 52,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    SvgPicture.asset(isChecked
                        ? "assets/images/vector_ic_type_properties_checked.svg"
                        : "assets/images/vector_ic_type_properties_normal.svg"),
                    SizedBox(width: 8),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColor.blackDefault,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: isChecked,
            child: Divider(
              color: AppColor.dividerGray,
              height: 1,
            ),
          ),
          Visibility(
            visible: isChecked,
            child: ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: _renderItemChild,
              itemCount: listCustom.length,
              padding: EdgeInsets.only(left: 48, right: 24),
              separatorBuilder: (c, i) {
                return Divider(
                  color: AppColor.dividerGray,
                  height: 1,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _renderItemChild(context, position) {
    return listCustom[position];
  }
}
