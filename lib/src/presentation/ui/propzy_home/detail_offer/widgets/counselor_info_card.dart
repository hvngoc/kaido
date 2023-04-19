import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class CounselorInfoCard extends StatefulWidget {
  const CounselorInfoCard({
    Key? key,
    required this.offerModel,
  }) : super(key: key);

  final HomeOfferModel offerModel;

  @override
  State<CounselorInfoCard> createState() => _CounselorInfoCardState();
}

class _CounselorInfoCardState extends State<CounselorInfoCard> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN');
  }

  @override
  Widget build(BuildContext context) {
    final hasScheduleTime = widget.offerModel.meeting?.scheduleTime != null;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Visibility(visible: hasScheduleTime, child: _renderResultBooking()),
            Visibility(visible: hasScheduleTime, child: Divider()),
            Row(
              children: [
                Text(
                  'Chuyên gia Propzy tư vấn miễn phí đề nghị mua',
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _makePhoneCall,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Gọi Propzy ngay')],
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColor.grayF4,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Gọi lại cho tôi')],
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColor.grayF4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall() async {
    await FlutterPhoneDirectCaller.callNumber("*4663");
  }

  Widget _renderResultBooking() {
    final scheduleTime = widget.offerModel.meeting?.scheduleTime;
    if (scheduleTime == null) {
      return Container();
    }
    var bookDate =
        DateTime.fromMillisecondsSinceEpoch(scheduleTime, isUtc: true);
    bookDate = bookDate.add(Duration(hours: 7));

    var formatter = DateFormat('d');
    final dayOfMonth = formatter.format(bookDate);

    formatter = DateFormat('EEEE', 'vi');
    final dayOfWeek = formatter.format(bookDate);

    formatter = DateFormat('MMMM, yyyy', 'vi');
    var monthAndYear = formatter.format(bookDate).replaceFirst('t', 'T');

    formatter = DateFormat('h:mm a', 'vi');
    var time = formatter
        .format(bookDate)
        .replaceFirst('SA', 'sáng')
        .replaceFirst('CH', 'chiều');

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/ic_iBuyer_calendar_check.svg',
                width: 21,
                height: 21,
              ),
              SizedBox(width: 8),
              Text(
                'Lịch hẹn',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayOfMonth,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: AppColor.green_iBuy,
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dayOfWeek),
                  Text(monthAndYear),
                ],
              ),
              Spacer(),
              SizedBox(width: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.green_bg_time,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.green_iBuy,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
