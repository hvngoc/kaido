import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class SortHeaderView extends StatelessWidget {
  const SortHeaderView(
      {Key? key,
      required this.title,
      required this.sortByTitle,
      required this.onClick})
      : super(key: key);

  final String title;
  final String sortByTitle;
  final GestureTapCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(right: 8),
          height: 40,
          child: Text(
            title,
            maxLines: 1,
            style: TextStyle(
              color: AppColor.blackDefault,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: InkWellWithoutRipple(
            onTap: onClick,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sắp xếp: ',
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColor.black_65p,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Flexible(
                  child: Text(
                    sortByTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColor.black_80p,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 26,
                  color: AppColor.gray89,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
