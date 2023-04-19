import 'package:flutter/material.dart';

class LandingHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Image.asset(
          'assets/images/landing_header.png',
        ),
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Text(
                'Đăng tin bán - cho thuê',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                'Hàng nghìn khách hàng đã hài lòng khi bán cùng\nPropzy',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
