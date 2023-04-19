import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';

class InvalidRequest extends StatelessWidget {
  const InvalidRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 240,
              child: Image(
                image: AssetImage('assets/images/img_invalid_request.png'),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Nhận ngay tư vấn từ chuyên gia',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Chuyên gia của Propzy sẽ liên hệ trong vòng 24 giờ để tư vấn cụ thể về nhu cầu bán của quý khách',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ReturnHomeButton(),
          ],
        ),
      ),
    );
  }
}
