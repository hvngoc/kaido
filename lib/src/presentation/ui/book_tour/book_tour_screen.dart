import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/view/contact_info_form.dart';
import 'package:propzy_home/src/presentation/view/select_book_date_time_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class BookTourScreen extends StatelessWidget {
  const BookTourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch xem căn nhà',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SelectBookDateTimeView(),
            ContactInfoForm(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.only(top: 12, bottom: 12),
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
                  'Đặt lịch xem',
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
