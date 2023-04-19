import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propzy_home/src/data/model/force_update_info.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class ForceUpdateDialog extends StatefulWidget {
  final ForceUpdateInfo? forceUpdateInfo;
  final GestureTapCallback? onTapUpdate;
  final GestureTapCallback? onTapShowMore;

  const ForceUpdateDialog(
      {Key? key,
      required this.forceUpdateInfo,
      this.onTapUpdate,
      this.onTapShowMore})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForceUpdateDialogState();
}

class _ForceUpdateDialogState extends State<ForceUpdateDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(
        12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
        child: Wrap(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/ic_rocket.png",
                    width: 64,
                    height: 64,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _renderContent(),
                  SizedBox(
                    height: 24,
                  ),
                  _renderButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderContent() => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: widget.forceUpdateInfo?.content ?? "",
              style: GoogleFonts.sourceSansPro(
                color: HexColor('363636'),
                fontSize: 14,
              ),
            ),
            (widget.forceUpdateInfo?.morel == true)
                ? TextSpan(
                    text: ' Tìm hiểu thêm',
                    style: GoogleFonts.sourceSansPro(
                      color: HexColor('007AFF'),
                      fontSize: 14,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                        widget.onTapShowMore?.call();
                      },
                  )
                : TextSpan(text: ''),
          ],
        ),
      );

  Widget _renderButton() {
    if (widget.forceUpdateInfo?.required == true) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                widget.onTapUpdate?.call();
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColor.orangeDark,
                ),
                child: Center(
                  child: Text(
                    'Cập nhật',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: HexColor('ADB5BD')),
                  color: HexColor('F0F0F0'),
                ),
                child: Center(
                  child: Text(
                    'Để sau',
                    style: TextStyle(
                      color: AppColor.blackDefault,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                widget.onTapUpdate?.call();
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColor.orangeDark,
                ),
                child: Center(
                  child: Text(
                    'Cập nhật',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
