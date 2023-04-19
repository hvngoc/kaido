import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class BoxDropDownTextView extends StatelessWidget {
  final String title;
  final String hint;
  final String? text;
  final String errorMessage;
  final GestureTapCallback? onTap;

  const BoxDropDownTextView(
      {Key? key,
      required this.title,
      required this.hint,
      required this.text,
      required this.errorMessage,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasData = (text?.isNotEmpty == true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColor.black_80p,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: !hasData ? AppColor.orangeDark : AppColor.grayD7, width: 1),
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 2),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      hasData ? text! : hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: hasData ? FontWeight.w500 : FontWeight.w400,
                        color: hasData ? AppColor.black_80p : AppColor.black_40p,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColor.gray55,
                    size: 24,
                  )
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: !hasData,
          child: Container(
            margin: EdgeInsets.only(top: 6, left: 6, right: 6),
            child: Text(
              errorMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColor.orangeDark,
              ),
            ),
          ),
        )
      ],
    );
  }
}
