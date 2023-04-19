import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class OrangeAppBar extends StatelessWidget with PreferredSizeWidget {
  const OrangeAppBar({
    Key? key,
    this.title = '',
    this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColor.orangeDark,
      leading: InkWell(
        onTap: () {
          onTap != null ? onTap?.call() : Navigator.of(context).pop();
        },
        child: Image(
          image: AssetImage(
            'assets/images/ic_back_propzy.png',
          ),
        ),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55);
}
