import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/propzy_home_bottom_sheet_information.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _renderHeaderView(),
            SizedBox(height: 46),
            _renderTitle(),
            SizedBox(height: 16),
            _renderSubTitle(),
            SizedBox(height: 83),
            _renderContent(),
            _renderFooter(),
          ],
        ),
      ),
    );
  }

  Widget _renderHeaderView() {
    return PropzyHomeHeaderView(
      isLoadOfferDetail: true,
    );
  }

  Widget _renderTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          "Khởi đầu thật tuyệt vời!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: HexColor("6A6D74"),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _renderSubTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Chưa đầy 3 phút tiếp theo để hoàn thành và nhận giá sơ bộ ngay  ",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.blackDefault,
        ),
      ),
    );
  }

  Widget _renderContent() {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/ic_summary_step_checked.svg",
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 32),
                Text(
                  "Nhập địa chỉ nhà",
                  style: TextStyle(
                    color: AppColor.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Container(
              width: 4,
              height: 64,
              margin: EdgeInsets.only(left: 14),
              color: AppColor.orangeDark,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/ic_summary_step_unchecked.svg",
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 32),
                Text(
                  "Miêu tả bất động sản và nhu cầu bán",
                  style: TextStyle(
                    color: AppColor.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Container(
              width: 4,
              height: 64,
              margin: EdgeInsets.only(left: 14),
              color: Color.fromRGBO(120, 120, 128, 0.2),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/ic_summary_step_unchecked_grey.svg",
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 32),
                Text(
                  "Hình ảnh bất động sản",
                  style: TextStyle(
                    color: AppColor.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Container(
              width: 4,
              height: 64,
              margin: EdgeInsets.only(left: 14),
              color: Color.fromRGBO(120, 120, 128, 0.2),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/ic_summary_step_unchecked_grey.svg",
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 32),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Nhận giá mua sơ bộ từ  Propzy  ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColor.secondaryText,
                        ),
                      ),
                      WidgetSpan(
                        child: InkWellWithoutRipple(
                          onTap: () {
                            showBottomSheetInformation();
                          },
                          child: SvgPicture.asset(
                            "assets/images/ic_info_propzy_home.svg",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderFooter() {
    return PropzyHomeContinueButton(
      isEnable: true,
      onClick: () {
        if (isApartment()) {
          NavigationController.navigateToIBuyApartmentStep1(context);
        } else {
          NavigationController.navigateToIBuyQAHomeStep1(context);
        }
      },
    );
  }

  bool isApartment() {
    return _propzyHomeBloc.propertyTypeSelected?.id == PROPERTY_TYPES.CHUNG_CU.type;
  }

  void showBottomSheetInformation() async {
    String contentHtml = await rootBundle.loadString(
        "assets/html/${PROPZY_HOME_POPUP_INFORMATION.PRELIMINARY_PURCHASE_PRICE_FROM_PROPZY.assetFileName}");

    showModalBottomSheet(
      // isScrollControlled: true,
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
