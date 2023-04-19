import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class SortItemChildView extends StatelessWidget {
  const SortItemChildView({
    Key? key,
    required this.text,
    required this.isChecked,
    required this.onClick,
    this.isAddMore = false,
    this.textAddMore = "",
  }) : super(key: key);

  final String text;
  final bool isChecked;
  final GestureTapCallback onClick;
  final bool isAddMore;
  final String textAddMore;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: 14,
          right: 14,
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isAddMore ? AppColor.blackDefault :AppColor.black_80p,
                  fontWeight: isAddMore ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(width: 5),
            Visibility(
              visible: isAddMore,
              child: Text(
                textAddMore,
                style: TextStyle(
                  color: AppColor.blueLink,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Visibility(
              visible: isChecked,
              child: Icon(
                Icons.check,
                size: 24,
                color: AppColor.orangeDark,
              ),
            )
          ],
        ),
      ),
    );
  }
}
