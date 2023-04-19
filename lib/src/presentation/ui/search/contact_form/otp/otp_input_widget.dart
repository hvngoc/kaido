import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class OtpInputScreen extends StatefulWidget {
  final String? phone;

  const OtpInputScreen({Key? key, this.phone}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(
                  color: AppColor.blackDefault,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                'Xác thực số điện thoại',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.blackDefault,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Nhập mã xác thực (OTP) được gửi đến số điện thoại ',
                      style: GoogleFonts.sourceSansPro(
                        color: AppColor.gray55,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: widget.phone,
                      style: GoogleFonts.sourceSansPro(
                        color: AppColor.blackDefault,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' của bạn',
                      style: GoogleFonts.sourceSansPro(
                        color: AppColor.gray55,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: PinCodeTextField(
                animationType: AnimationType.scale,
                length: 6,
                appContext: context,
                cursorColor: AppColor.orangeDark,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeColor: AppColor.orangeDark,
                  inactiveColor: AppColor.orangeDark,
                  selectedColor: AppColor.orangeDark,
                ),
                onChanged: (String value) {},
              ),
            ),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => AppColor.rippleDark),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/images/vector_ic_resend_otp.svg'),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Gửi lại mã OTP',
                    style: TextStyle(
                      color: AppColor.blueLink,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Mã OTP của bạn sẽ hết hiệu lực sau ',
                      style: GoogleFonts.sourceSansPro(
                        color: AppColor.secondaryText,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: '1',
                      style: GoogleFonts.sourceSansPro(
                        color: AppColor.blackDefault,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: ' phút ',
                      style: GoogleFonts.sourceSansPro(
                        color: AppColor.secondaryText,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: '19',
                      style: GoogleFonts.sourceSansPro(
                        color: AppColor.blackDefault,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: ' giây.',
                      style: GoogleFonts.sourceSansPro(
                        color: AppColor.secondaryText,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: EdgeInsets.only(
                top: 12,
                bottom: 12,
              ),
              height: 64,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColor.orangeDark),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => AppColor.rippleLight),
                ),
                onPressed: () {},
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
