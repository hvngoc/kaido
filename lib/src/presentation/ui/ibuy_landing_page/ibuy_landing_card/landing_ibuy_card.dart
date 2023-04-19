import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/presentation/ui/ibuy_landing_page/bloc/ibuy_landing_page_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_web_view/propzy_web_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class LandingIBuyCard extends StatelessWidget {
  final IbuyLandingPageBloc _bloc = GetIt.instance.get<IbuyLandingPageBloc>();
  final PrefHelper prefHelper = GetIt.instance.get<PrefHelper>();

  LandingIBuyCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 24,
            bottom: 8,
          ),
          child: Image.asset(
            'assets/images/ic_landing_ibuy.png',
            fit: BoxFit.contain,
            width: 154,
            height: 155,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.of(context).size.width - 145,
            padding: EdgeInsets.only(
              right: 24,
            ),
            child: Column(
              children: [
                Text(
                  'Bán cho Propzy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: HexColor('#F26922'),
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Propzy trực tiếp mua nhà, khách hàng nhận giá đề nghị ngay sau khi hoàn tất gửi yêu cầu bán.',
                        style: GoogleFonts.sourceSansPro(
                          color: HexColor('#4A4A4A'),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: '\nTìm hiểu thêm',
                        style: GoogleFonts.sourceSansPro(
                          color: AppColor.blueLink,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropzyWebView(
                                  url: 'https://propzy.vn',
                                ),
                              ),
                            );
                          },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                BlocListener(
                  bloc: _bloc,
                  listener: (context, state) {
                    // TODO: implement listener
                    Util.hideLoading();
                    if (state is IbuyLandingPageLoadingState) {
                      Util.showLoading();
                    } else if (state is IbuyLandingPageErrorSingleSignOnState) {
                      //Util.showMyDialog(context: context, message: 'Lỗi');
                    } else if (state is IbuyLandingPageSuccessSingleSignOnState) {
                      if (state.isGoToIBuy) {
                        NavigationController.navigateToIBuyPropertyType(context);
                      }
                    }
                  },
                  child: OutlinedButton(
                    onPressed: () async {
                      String? accessToken = await prefHelper.getAccessToken();
                      if (accessToken?.isNotEmpty == true) {
                        NavigationController.navigateToIBuyPropertyType(context);
                      } else {
                        _bloc.add(IbuyLandingPageSingleSignOnRequestEvent(true));
                      }
                    },
                    child: Text(
                      'Bán ngay',
                      style: TextStyle(
                        color: AppColor.propzyOrange,
                        fontSize: 16,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 42,
                        right: 42,
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        width: 1,
                        color: AppColor.propzyOrange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
