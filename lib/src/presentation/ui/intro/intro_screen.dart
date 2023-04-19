import 'dart:async';

import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/log.dart';

import '../../view/pager_with_dot.dart';
import 'intro_widget.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  static const int MAX_PAGE = 3;

  late PageController controller;
  int currentPageValue = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentPageValue);
    initTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final List<IntroWidget> introWidgetsList = <IntroWidget>[
      const IntroWidget(
        animationFile: "assets/json/introduce1.json",
        textTitle: "Dịch vụ của chúng tôi",
        textSubTitle: "Cung cấp và cập nhật liên tục thông tin Bất Động Sản minh bạch và rõ ràng.",
        visibleButton: false,
      ),
      const IntroWidget(
        animationFile: "assets/json/introduce2.json",
        textTitle: "Chất lượng - Hiệu quả",
        textSubTitle: "Kết nối khách hàng có nhu cầu mua thực và có đủ năng lực tài chính.",
        visibleButton: false,
      ),
      const IntroWidget(
        animationFile: "assets/json/introduce3.json",
        textTitle: "Minh bạch - An toàn - Tiện lợi",
        textSubTitle:
            "Cộng đồng môi giới hoạt động dựa trên những quy định rõ ràng khi tham gia, chia sẻ lợi ích chung một cách công bằng trong các giao dịch hợp tác.",
        visibleButton: true,
      ),
    ];

    return Scaffold(
      body: PagerDotIndicator(
        listWidgets: introWidgetsList,
        controller: controller,
        onPageChanged: (int page) {
          getChangedPageAndMoveBar(page);
        },
        currentPageValue: currentPageValue,
        indicatorNormalColor: AppColor.gray89,
        indicatorSelectedColor: AppColor.orangeDark,
      ),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    Log.i('page is $page');
    currentPageValue = page;
    setState(() {});
    _timer?.cancel();
    initTimer();
  }

  void initTimer() {
    _timer = Timer(const Duration(seconds: 4), () {
      Log.w('Timer tick: $currentPageValue');
      if (currentPageValue < MAX_PAGE - 1) {
        currentPageValue = currentPageValue + 1;
        controller.animateToPage(
          currentPageValue,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }
}
