import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/propzy_home_bottom_sheet_information.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/bloc/purchase_price_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/widgets/home_select_date_time_dialog.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:propzy_home/src/util/constants.dart';

class PriceInfoCard extends StatefulWidget {
  const PriceInfoCard({
    Key? key,
    required this.offerId,
    required this.offerModel,
  }) : super(key: key);

  final int offerId;
  final HomeOfferModel offerModel;

  @override
  State<PriceInfoCard> createState() => _PriceInfoCardState();
}

class _PriceInfoCardState extends State<PriceInfoCard> {
  DateTime? bookingDate;

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
            Container(
              child: PropzyHomeProgressPage(offerId: widget.offerId),
            ),
            _renderPriceInfo(),
            SizedBox(height: 24),
            Visibility(visible: !hasScheduleTime, child: _renderBookDate()),
            Visibility(visible: hasScheduleTime, child: _renderResultBooking()),
          ],
        ),
      ),
    );
  }

  Widget _renderCalendarButton() {
    final placeHolder = 'Chọn thời gian đi xem';
    final formatString = 'dd/MM/yyyy - HH:mm';
    final formatter = DateFormat(formatString);
    final bookDateString =
        bookingDate != null ? formatter.format(bookingDate!) : placeHolder;
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => HomeSelectDateTimeDialog(
            onPressSelect: (dateTime) {
              setState(() {
                bookingDate = dateTime;
              });
            },
          ),
        );
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: AppColor.grayC6),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(bookDateString),
            SvgPicture.asset(
              'assets/images/ic_iBuyer_calendar.svg',
              height: 21,
              width: 21,
            ),
          ],
        ),
      ),
    );
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
      padding: EdgeInsets.all(1),
      decoration: DottedDecoration(
        shape: Shape.box,
        borderRadius: BorderRadius.circular(4),
        color: AppColor.propzyBlue100,
        strokeWidth: 2,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: AppColor.grayF9,
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
                  'Lịch hẹn của quý khách',
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
      ),
    );
  }

  Widget _renderBookDate() {
    final priceValue = widget.offerModel.suggestedPriceFormat ??
        widget.offerModel.formatPrice ??
        '';
    return Container(
      padding: EdgeInsets.all(1),
      decoration: DottedDecoration(
        shape: Shape.box,
        borderRadius: BorderRadius.circular(4),
        color: AppColor.propzyBlue100,
        strokeWidth: 2,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: AppColor.grayF9,
        child: Column(
          children: [
            Text(
              'Đặt lịch thẩm định nhà với chuyên gia',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: 'Hoặc chuyên gia của Propzy sẽ chủ động liên hệ bạn ',
                children: [
                  TextSpan(
                    text: 'trong vòng 24 giờ',
                    style: TextStyle(
                      color: AppColor.propzyBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (priceValue.isEmpty)
                    TextSpan(
                      text: ' để đưa ra giá đề nghị mua dành riêng cho bạn',
                    ),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 24),
            Align(
              child: Text(
                'Thời gian đi xem',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(height: 8),
            _renderCalendarButton(),
            SizedBox(height: 24),
            OrangeButton(
              title: 'Đặt lịch hẹn',
              isEnabled: bookingDate != null,
              onPressed: () {
                context.read<PurchasePriceBloc>().add(
                      CallScheduleOfferEvent(
                        HomeScheduleOfferModel(
                          offerId: widget.offerId,
                          scheduleTime: '${bookingDate!.millisecondsSinceEpoch}',
                        ),
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderPriceInfo() {
    final priceValue = widget.offerModel.suggestedPriceFormat ??
        widget.offerModel.formatPrice ??
        '';
    if (priceValue.isEmpty) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Column(
        children: [
          Text(
            'Giá đề nghị sơ bộ',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              showBottomSheetInformation();
            },
            splashColor: Colors.transparent,
            child: Text.rich(
              TextSpan(
                text:
                'Giá đề nghị sơ bộ là ước tính tự động của Propzy về giá trị thị trường cho ngôi nhà của bạn, đây không phải là giá đề nghị cuối cùng và chỉ được sử dụng để tham khảo ban đầu, chuyên gia Propzy sẽ liên hệ với bạn để đưa ra giá đề nghị mua cuối cùng.  ',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.propzyHomeDes,
                ),
                children: [
                  WidgetSpan(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: Image(
                        image:
                        AssetImage('assets/images/ic_question_circle.png'),
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          Text(
            priceValue,
            style: TextStyle(
              color: AppColor.orangeDark,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void showBottomSheetInformation() async {
    String contentHtml = await rootBundle.loadString(
        "assets/html/${PROPZY_HOME_POPUP_INFORMATION.PRELIMINARY_PURCHASE_PRICE_FROM_PROPZY.assetFileName}");

    showModalBottomSheet(
      context: context,
      builder: (context) => PropzyHomeBottomSheetInformation(contentHtml: contentHtml),
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),
      ),
    );
  }
}
