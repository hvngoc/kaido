import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class HeaderBarView extends StatelessWidget {
  const HeaderBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.white,
      shadowColor: AppColor.dividerGray,
      child: Stack(
        children: [
          BackButton(
            color: AppColor.secondaryText,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Container(
            alignment: Alignment.center,
            height: 52,
            child: Text(
              'Đăng tin bất động sản',
              style: TextStyle(
                color: AppColor.blackDefault,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
