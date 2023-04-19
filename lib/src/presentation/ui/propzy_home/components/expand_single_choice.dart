import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/domain/model/propzy_home_feature.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class ExpandSingleChoice extends StatelessWidget {
  final HomeFeature feature;
  final Function(HomeFeature) onSectionTap;
  final Function(HomeFeatureChildren) onChildTap;

  const ExpandSingleChoice({
    Key? key,
    required this.feature,
    required this.onSectionTap,
    required this.onChildTap,
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
              onTap: () {
                onSectionTap(feature);
              },
              child: Container(
                height: 52,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    SvgPicture.asset(feature.isChecked
                        ? "assets/images/vector_ic_type_properties_checked.svg"
                        : "assets/images/vector_ic_type_properties_normal.svg"),
                    SizedBox(width: 8),
                    Text(
                      feature.name ?? '',
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
            visible: feature.isChecked,
            child: Divider(
              color: AppColor.dividerGray,
              height: 1,
            ),
          ),
          Visibility(
            visible: feature.isChecked,
            child: ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: _renderItemChild,
              itemCount: feature.chill?.length ?? 0,
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
    return Material(
      color: AppColor.white,
      child: InkWell(
        onTap: () {
          onChildTap(feature.chill![position]);
        },
        child: Container(
          padding: EdgeInsets.only(left: 48, right: 24),
          height: 52,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  feature.chill![position].name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColor.blackDefault,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Visibility(
                visible: feature.chill![position].isChecked,
                child: Icon(
                  Icons.check_outlined,
                  color: AppColor.systemBlue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
