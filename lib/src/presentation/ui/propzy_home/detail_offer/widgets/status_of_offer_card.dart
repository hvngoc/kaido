import 'dart:ffi';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/process_view/propzy_home_process_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/propzy_home_bottom_sheet_information.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/confirm_owner/confirm_owner.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/contact_info/contact_info.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_1/apartment_step_1.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_2/apartment_step_2.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_1/information_step_1.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_10/information_step_10.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_2/information_step_2.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_3/information_step_3.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_4/information_step_4.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_5/information_step_5.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_6/information_step_6.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_7/information_step_7.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_8/information_step_8.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_9/information_step_9.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/property_media.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_type/property_type.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/widgets/home_select_date_time_dialog.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/summary/summary.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'dart:ui' as DartUI;

import 'package:propzy_home/src/util/navigation_controller.dart';

class StatusOfOfferCard extends StatefulWidget {
  const StatusOfOfferCard({
    Key? key,
    required this.offerId,
    required this.offerModel,
  }) : super(key: key);

  final int offerId;
  final HomeOfferModel offerModel;

  @override
  State<StatusOfOfferCard> createState() => _StatusOfOfferCardState();
}

class _StatusOfOfferCardState extends State<StatusOfOfferCard> {
  DateTime? bookingDate;
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //PropzyHomeProcessPage(offerId: widget.offerId),
            SizedBox(height: 16),
            _renderStatusInfo(),
          ],
        ),
      ),
    );
  }

  Widget _renderStatusInfo() {
    final statusId = widget.offerModel.status?.id;
    if (statusId != null) {
      if (statusId == 1) {
        return _renderIncompleteStatus();
      } else if (statusId == 2) {
        return _renderNotYetAppraisedStatus();
      } else if (statusId == 3) {
        return _renderAppraisalStatus();
      } else if (statusId == 4) {
        return _renderSentPreliminaryStatus(true);
      } else if (statusId == 5) {
        return _renderSentPreliminaryStatus(false);
      } else if (statusId == 6) {
        return _renderSoldStatus();
      } else if (statusId == 10) {
        return _renderFailStatus();
      }
    }
    return Container();
  }

  Widget _renderIncompleteStatus() {
    return Column(
      children: [
        _renderItemTitleDescriptionInfo(
          'Chưa đủ thông tin để đưa ra giá đề nghị sơ bộ',
          'Bạn vui lòng bổ sung đầy đủ các thông tin còn thiếu để nhận giá đề nghị sơ bộ từ Propzy',
        ),
        SizedBox(height: 24),
        OrangeButton(
          title: 'Bổ sung ngay',
          onPressed: onPressButtonAddNow,
        ),
      ],
    );
  }

  Widget _renderNotYetAppraisedStatus() {
    final suggestedPriceFormat = widget.offerModel.suggestedPriceFormat ?? '';
    if (suggestedPriceFormat.isNotEmpty) {
      return Column(
        children: [
          Text(
            'Giá đề nghị sơ bộ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),
          InkWell(
            onTap: () {
              showBottomSheetInformation();
            },
            splashColor: Colors.transparent,
            child: Text.rich(
              TextSpan(
                text:
                    'Giá đề nghị sơ bộ là ước tính tự động của Propzy về giá trị thị trường cho ngôi nhà của bạn, đây không phải là giá đề nghị cuối cùng và chỉ được sử dụng để tham khảo ban đầu, chuyên gia chúng tôi sẽ liên hệ với bạn để đưa ra giá đề nghị mua chính thức.  ',
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
                        image: AssetImage('assets/images/ic_question_circle.png'),
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          _renderItemPriceView(''),
        ],
      );
    } else {
      return Column(
        children: [
          _renderItemTitleDescriptionInfo(
            'Giá đề nghị mua chính thức đang được chuẩn bị',
            'Chuyên gia Propzy đang phân tích để đưa ra giá đề nghị chính thức dành riêng cho bạn',
          ),
          SizedBox(height: 16),
          _renderItemBookDate(),
        ],
      );
    }
  }

  Widget _renderAppraisalStatus() {
    final offeredPriceFormat = widget.offerModel.offeredPriceFormat ?? '';
    final suggestedPriceFormat = widget.offerModel.suggestedPriceFormat ?? '';
    if (offeredPriceFormat.isNotEmpty) {
      return Column(
        children: [
          _renderItemTitleDescriptionInfo('Giá đề nghị mua chính thức từ Propzy',
              'Propzy trân trọng đưa ra giá đề nghị mua bất động sản của bạn sau quá trình thẩm định thực tế từ chuyên gia như sau:'),
          SizedBox(height: 16),
          _renderItemPriceView(''),
        ],
      );
    } else if (suggestedPriceFormat.isNotEmpty) {
      return Column(
        children: [
          Text(
            'Giá đề nghị sơ bộ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),
          InkWell(
            onTap: () {
              showBottomSheetInformation();
            },
            child: Text.rich(
              TextSpan(
                text:
                    'Giá đề nghị sơ bộ là ước tính tự động của Propzy về giá trị thị trường cho ngôi nhà của bạn, đây không phải là giá đề nghị cuối cùng và chỉ được sử dụng để tham khảo ban đầu, chuyên gia chúng tôi sẽ liên hệ với bạn để đưa ra giá đề nghị mua chính thức.  ',
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
                        image: AssetImage('assets/images/ic_question_circle.png'),
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          _renderItemPriceView(''),
        ],
      );
    } else {
      return Column(
        children: [
          _renderItemTitleDescriptionInfo(
            'Giá đề nghị mua chính thức đang được chuẩn bị',
            'Chuyên gia Propzy đang phân tích để đưa ra giá đề nghị chính thức dành riêng cho bạn',
          ),
          SizedBox(height: 16),
          _renderItemBookDate(),
        ],
      );
    }
  }

  Widget _renderSentPreliminaryStatus(bool actionButton) {
    String dateString = '--';
    final suggestedPriceExpired = widget.offerModel.suggestedPriceExpired ?? 0;
    if (suggestedPriceExpired > 0) {
      dateString = getDateFromTimeInterval(suggestedPriceExpired);
    }
    return Column(
      children: [
        _renderItemTitleDescriptionInfo(
          'Giá đề nghị mua chính thức từ Propzy',
          'Propzy trân trọng đưa ra giá đề nghị mua bất động sản của bạn sau quá trình thẩm định thực tế từ chuyên gia như sau:',
        ),
        SizedBox(height: 16),
        _renderItemPriceView('Hiệu lực đến: ${dateString}'),
        SizedBox(height: 16),
        Visibility(visible: actionButton, child: _renderActionButtons()),
      ],
    );
  }

  Widget _renderSoldStatus() {
    return Column(
      children: [
        _renderItemTitleDescriptionInfo(
          'Bán nhà thành công',
          'Propzy trân trọng cám ơn bạn đã tin tưởng và lựa chọn bán nhà cùng Propzy.',
        ),
        SizedBox(height: 16),
        _renderItemSuccessfulSoldImage(),
        SizedBox(height: 16),
        _renderItemPriceView('Đã bán cho Propzy thành công !'),
      ],
    );
  }

  Widget _renderFailStatus() {
    final reasonName = widget.offerModel.actionCancel?.reasonName ?? '';
    final description = reasonName.isNotEmpty
        ? 'Lý do từ chối: ${reasonName}'
        : 'Lý do từ chối: Giá tham khảo được hệ thống công nghệ của Propzy phân tích dựa trên dữ liệu thị trường và thông tin bạn cung cấp';
    return Column(
      children: [
        _renderItemTitleDescriptionInfo(
          'Đề nghị không thành công',
          description,
        ),
        SizedBox(height: 16),
        _renderItemFailImage(),
      ],
    );
  }

  Widget _renderItemTitleDescriptionInfo(String title, String description) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColor.propzyHomeDes,
          ),
        ),
      ],
    );
  }

  Widget _renderItemSuccessfulSoldImage() {
    return SizedBox(
      width: 64,
      height: 64,
      child: Image(
        image: AssetImage('assets/images/ic_successfully_sold.png'),
      ),
    );
  }

  Widget _renderItemFailImage() {
    return SizedBox(
      height: 60,
      width: 95,
      child: Image(image: AssetImage('assets/images/ic_failse_sold.png')),
    );
  }

  Widget _renderItemPriceView(String moreInfo) {
    final successPriceColor = Color(0xFF248A3D);
    final suggestedPriceColor = Color(0xFFF17423);

    final statusId = widget.offerModel.status?.id ?? 0;
    final priceColor = statusId == 6 ? successPriceColor : suggestedPriceColor;
    Color moreInfoColor = Color(0xFF363636);
    if (statusId == 6) {
      moreInfoColor = successPriceColor;
    }

    final offeredPriceFormat = widget.offerModel.offeredPriceFormat ?? '';
    final formatPrice = widget.offerModel.formatPrice ?? '';
    final suggestedPriceFormat = widget.offerModel.suggestedPriceFormat ?? '';
    String priceString = '';
    if (offeredPriceFormat.isNotEmpty && offeredPriceFormat != 'N/A') {
      priceString = offeredPriceFormat;
    } else if (formatPrice.isNotEmpty && formatPrice != 'N/A') {
      priceString = formatPrice;
    } else if (suggestedPriceFormat.isNotEmpty && suggestedPriceFormat != 'N/A') {
      priceString = suggestedPriceFormat;
    } else {
      return Container();
    }

    return Column(
      children: [
        Text(
          priceString,
          style: TextStyle(
            color: priceColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Visibility(
          visible: moreInfo.isNotEmpty,
          child: Text(
            moreInfo,
            style: TextStyle(
              color: moreInfoColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderItemBookDate() {
    final priceValue =
        widget.offerModel.suggestedPriceFormat ?? widget.offerModel.formatPrice ?? '';
    final scheduleTime = widget.offerModel.meeting?.scheduleTime;
    if (scheduleTime != null) {
      return Container();
    }
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
                // context.read<PurchasePriceBloc>().add(
                //   CallScheduleOfferEvent(
                //     HomeScheduleOfferModel(
                //       offerId: widget.offerId,
                //       scheduleTime: '${bookingDate!.millisecondsSinceEpoch}',
                //     ),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderCalendarButton() {
    final placeHolder = 'Chọn thời gian đi xem';
    final formatString = 'dd/MM/yyyy - HH:mm';
    final formatter = DateFormat(formatString);
    final bookDateString = bookingDate != null ? formatter.format(bookingDate!) : placeHolder;
    return InkWell(
      onTap: () {
        showBottomSheet(
          context: context,
          builder: (_) => HomeSelectDateTimeDialog(
            onPressSelect: (dateTime) {
              print('select $dateTime');
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

  Widget _renderActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OrangeButton(
            title: 'Từ chối',
            defaultActiveColor: AppColor.gray500,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: OrangeButton(
            title: 'Đồng ý đề nghị',
          ),
        ),
      ],
    );
  }

  String getDateFromTimeInterval(int timeInterval) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeInterval);
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  void showBottomSheetInformation() async {
    String contentHtml = await rootBundle.loadString(
        "assets/html/${PROPZY_HOME_POPUP_INFORMATION.PRELIMINARY_PURCHASE_PRICE_FROM_PROPZY.assetFileName}");

    showModalBottomSheet(
      context: context,
      builder: (context) => PropzyHomeBottomSheetInformation(contentHtml: contentHtml),
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints.loose(
        DartUI.Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),
      ),
    );
  }

  bool isApartment() => widget.offerModel.propertyType?.id == PROPERTY_TYPES.CHUNG_CU.type;

  void onPressButtonAddNow() {
    List<Widget> widgets = [];
    String? pageCode = widget.offerModel.reachedPage?.code;

    if (PropzyHomeScreenDirect.MAP_SEARCH_LOCATION.pageCode == pageCode ||
        PropzyHomeScreenDirect.MAP_SEARCH_LOCATION_RESULT.pageCode == pageCode ||
        PropzyHomeScreenDirect.MAP_LOCATION_CORRECT.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
      ];
    } else if (PropzyHomeScreenDirect.PROCESS_OVERVIEW.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
    } else if (PropzyHomeScreenDirect.HOUSE_TEXTURE.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
        HomeInformationStep1(),
      ];
    } else if (PropzyHomeScreenDirect.APARTMENT_SIZE.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
        ApartmentStep1(),
      ];
    } else if (PropzyHomeScreenDirect.APARTMENT_DETAIL.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
        ApartmentStep1(),
        ApartmentStep2(),
      ];
    } else if (PropzyHomeScreenDirect.HOUSE_POSITION.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
        HomeInformationStep1(),
        HomeInformationStep2(),
      ];
    } else if (PropzyHomeScreenDirect.HOUSE_SIZE.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
        HomeInformationStep1(),
        HomeInformationStep2(),
        HomeInformationStep3(),
      ];
    } else if (PropzyHomeScreenDirect.NUMBER_OF_ROOMS.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
        HomeInformationStep1(),
        HomeInformationStep2(),
        HomeInformationStep3(),
        HomeInformationStep4(),
      ];
    } else if (PropzyHomeScreenDirect.CERTIFICATE_LAND.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
      ]);
    } else if (PropzyHomeScreenDirect.YEAR_BUILT.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
        HomeInformationStep6(),
      ]);
    } else if (PropzyHomeScreenDirect.EXPECTED_TIME.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
        HomeInformationStep6(),
        HomeInformationStep7(),
      ]);
    } else if (PropzyHomeScreenDirect.EXPECTED_PRICE.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
        HomeInformationStep6(),
        HomeInformationStep7(),
        HomeInformationStep8(),
      ]);
    } else if (PropzyHomeScreenDirect.UPLOAD_IMG.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
        HomeInformationStep6(),
        HomeInformationStep7(),
        HomeInformationStep8(),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_MEDIA),
      ]);
    } else if (PropzyHomeScreenDirect.CERTIFICATE_IMG.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
        HomeInformationStep6(),
        HomeInformationStep7(),
        HomeInformationStep8(),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_MEDIA),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_LEGAL),
      ]);
    } else if (PropzyHomeScreenDirect.OWNER_TYPE.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
        HomeInformationStep6(),
        HomeInformationStep7(),
        HomeInformationStep8(),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_MEDIA),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_LEGAL),
        ConfirmOwnerScreen(),
      ]);
    } else if (PropzyHomeScreenDirect.CONTACT_INFO.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
        HomeInformationStep6(),
        HomeInformationStep7(),
        HomeInformationStep8(),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_MEDIA),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_LEGAL),
        ConfirmOwnerScreen(),
        ContactInfoScreen(),
      ]);
    } else if (PropzyHomeScreenDirect.PLAN_TO_BUY.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
        HomeInformationStep6(),
        HomeInformationStep7(),
        HomeInformationStep8(),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_MEDIA),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_LEGAL),
        ConfirmOwnerScreen(),
        ContactInfoScreen(),
        HomeInformationStep9(),
      ]);
    } else if (PropzyHomeScreenDirect.PLAN_INFO.pageCode == pageCode) {
      widgets = [
        PropertyTypeScreen(isResetOffer: false),
        PickAddressScreen(),
        SummaryScreen(),
      ];
      widgets.addAll(getListStep(isApartment()));
      widgets.addAll([
        HomeInformationStep5(),
        HomeInformationStep6(),
        HomeInformationStep7(),
        HomeInformationStep8(),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_MEDIA),
        PropertyMedia(offerId: widget.offerId, typeSource: Constants.MEDIA_SOURCE_TYPE_LEGAL),
        ConfirmOwnerScreen(),
        ContactInfoScreen(),
        HomeInformationStep9(),
        HomeInformationStep10(),
      ]);
    }

    NavigationController.navigateToWidgets(context, widgets);
  }

  List<Widget> getListStep(bool isApartment) {
    if (isApartment) {
      return [
        ApartmentStep1(),
        ApartmentStep2(),
      ];
    } else {
      return [
        HomeInformationStep1(),
        HomeInformationStep2(),
        HomeInformationStep3(),
        HomeInformationStep4(),
      ];
    }
  }
}
