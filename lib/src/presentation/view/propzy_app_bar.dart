import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class PropzyAppBar extends StatelessWidget with PreferredSizeWidget {
  const PropzyAppBar({
    Key? key,
    this.title = '',
    this.onBack,
    this.backImage,
    this.titleStyle,
    this.backgroundColor,
    this.actions,
    this.showBackButton = true,
    this.showDialogWarning = true,
  }) : super(key: key);

  final String title;
  final VoidCallback? onBack;
  final Image? backImage;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showDialogWarning;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: titleStyle ??
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.secondaryText,
            ),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ?? AppColor.white,
      leading: _renderBack(context),
      actions: actions ??
          [
            InkWell(
              onTap: () {
                if (showDialogWarning) {
                  _showAlertDialog(context);
                } else {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }
              },
              child: Container(
                // height: double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: SvgPicture.asset(
                  'assets/images/ic_home_listing.svg',
                ),
              ),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55);

  Widget? _renderBack(BuildContext context) {
    if (!showBackButton) {
      return null;
    }
    if (backImage != null) {
      return InkWell(
        onTap: () {
          onBack != null ? onBack?.call() : Navigator.of(context).pop();
        },
        child: backImage,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      );
    }
    return BackButton(
      color: AppColor.secondaryText,
      onPressed: () {
        onBack != null ? onBack?.call() : Navigator.of(context).pop();
      },
    );
  }

  void _showAlertDialog(BuildContext context) {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8.0,
        ),
      ), //this right here
      child: Container(
        padding: EdgeInsets.all(
          12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  },
                  child: SvgPicture.asset(
                    'assets/images/ic_close.svg',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Bạn có muốn quay về trang trước đó?',
                    style: TextStyle(
                      color: AppColor.blackDefault,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: 40,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.grayD5,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Không, Cảm ơn',
                            style: TextStyle(
                              color: AppColor.blackDefault,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: 40,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.propzyOrange,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        // close popup
                        Navigator.of(context, rootNavigator: true).pop();
                        // back to root
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Row(
                        children: [
                          Text(
                            'Có',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
