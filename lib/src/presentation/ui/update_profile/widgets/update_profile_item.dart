import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class UpdateProfileItem extends StatefulWidget {
  UpdateProfileItem({
    required this.name,
    required this.iconPath,
    required this.defaultValue,
  });

  final String name;
  final String iconPath;
  final String defaultValue;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpdateProfileItemState();
  }
}

class UpdateProfileItemState extends State<UpdateProfileItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
        ),
        Text(
          widget.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: HexColor('#474747'),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Image.asset(
              widget.iconPath,
              width: 20,
              height: 20,
            ),
            SizedBox(
              width: 13,
            ),
            Expanded(
              child: TextField(
                enableInteractiveSelection: false,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                decoration: InputDecoration.collapsed(
                  hintText: widget.defaultValue,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.blackDefault,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.blackDefault,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Divider(
          color: AppColor.dividerGray,
          height: 1,
        ),
      ],
    );
  }
}
