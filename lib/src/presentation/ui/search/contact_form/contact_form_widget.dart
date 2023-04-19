import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_district/choose_district_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/choose_type_buy_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/choose_type_rent_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/otp/otp_input_widget.dart';
import 'package:propzy_home/src/presentation/view/box_drop_down_text.dart';
import 'package:propzy_home/src/presentation/view/box_input_with_validation.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/util.dart';

class ContactFormSearchView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactFormSearchView> {
  String? name = null;
  String? phone = null;
  String? email = null;
  ChooserData? district = null;
  CategoryType categoryType = CategoryType.BUY;
  ChooserData? categoryProperties = null;

  @override
  Widget build(BuildContext context) {
    bool isEmail = email == null || email!.isEmpty || EmailValidator.validate(email!);
    bool isPhone = Util.isPhoneNumber(phone);
    bool isName = name != null && name!.isNotEmpty;

    bool isValidAll = isEmail & isPhone & isName && district != null && categoryProperties != null;

    bool isTypeBuy = categoryType == CategoryType.BUY;
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
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Trao đổi với Propzy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.secondaryText,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                'Bắt đầu trò chuyện với chuyên gia nhà đất của Propzy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.gray4A,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BoxDropDownTextView(
                title: 'Bạn muốn tìm nhà khu vực nào',
                hint: 'Chọn Quận/Huyện',
                text: district?.name,
                errorMessage: 'Vui lòng chọn Quận/Huyện',
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseDistrictScreen(lastChooser: district),
                    ),
                  );
                  final data = result[BaseChooserScreen.PARAM] as ChooserData;
                  setState(() {
                    this.district = data;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (!isTypeBuy) {
                        setState(() {
                          categoryType = CategoryType.BUY;
                          categoryProperties = null;
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Row(
                        children: [
                          SvgPicture.asset(isTypeBuy
                              ? "assets/images/vector_ic_check_type_selected.svg"
                              : "assets/images/vector_ic_check_type_normal.svg"),
                          SizedBox(width: 8),
                          Text(
                            'Mua',
                            style: TextStyle(
                              color: AppColor.gray4A,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  InkWell(
                    onTap: () {
                      if (isTypeBuy) {
                        setState(() {
                          categoryType = CategoryType.RENT;
                          categoryProperties = null;
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Row(
                        children: [
                          SvgPicture.asset(!isTypeBuy
                              ? "assets/images/vector_ic_check_type_selected.svg"
                              : "assets/images/vector_ic_check_type_normal.svg"),
                          SizedBox(width: 8),
                          Text(
                            'Thuê',
                            style: TextStyle(
                              color: AppColor.gray4A,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BoxDropDownTextView(
                title: 'Loại hình bđs đang tìm kiếm',
                hint: 'Chọn loại bđs',
                text: categoryProperties?.name,
                errorMessage: 'Vui lòng chọn Loại hình bất động sản',
                onTap: () async {
                  final screen = isTypeBuy
                      ? ChoosePropertiesBuyScreen(lastChooser: categoryProperties)
                      : ChoosePropertiesRentScreen(lastChooser: categoryProperties);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen),
                  );
                  final data = result[BaseChooserScreen.PARAM] as ChooserData;
                  setState(() {
                    this.categoryProperties = data;
                  });
                },
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BoxInputWithValidation(
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                onChanged: (name) {
                  setState(() {
                    this.name = name;
                  });
                },
                title: 'Họ tên*',
                hint: 'Nhập họ và tên',
                isError: !isName,
                errorMessage: 'Vui lòng nhập Họ tên của bạn',
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BoxInputWithValidation(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onChanged: (phone) {
                  setState(() {
                    this.phone = phone;
                  });
                },
                title: 'Số điện thoại*',
                hint: 'Nhập số điện thoại',
                isError: !isPhone,
                errorMessage: 'Vui lòng nhập số điện thoại hợp lệ.',
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BoxInputWithValidation(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onChanged: (email) {
                  setState(() {
                    this.email = email;
                  });
                },
                title: 'Email',
                hint: 'Nhập email',
                isError: !isEmail,
                errorMessage: 'Vui lòng nhập địa chỉ email hợp lệ.',
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.only(top: 12, bottom: 12),
              height: 64,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      isValidAll ? AppColor.orangeDark : AppColor.gray500),
                  overlayColor: MaterialStateColor.resolveWith((states) => AppColor.rippleLight),
                ),
                onPressed: isValidAll
                    ? () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OtpInputScreen(phone: phone)),
                        );
                      }
                    : null,
                child: Text(
                  'Gửi',
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
