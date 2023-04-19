import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../../data/local/pref/pref_helper.dart';
import '../../../util/app_colors.dart';
import '../home/home.dart';

class IntroWidget extends StatefulWidget {
  const IntroWidget(
      {Key? key,
      required this.animationFile,
      required this.textTitle,
      required this.textSubTitle,
      required this.visibleButton})
      : super(key: key);

  final String animationFile;
  final String textTitle;
  final String textSubTitle;
  final bool visibleButton;

  @override
  State<StatefulWidget> createState() {
    return IntroState();
  }
}

class IntroState extends State<IntroWidget> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final locator = GetIt.instance;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_introduce.png'),
              fit: BoxFit.cover)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Image.asset('assets/images/bg_introduce_white.png',
                  fit: BoxFit.contain, height: 340, width: double.infinity),
              Image.asset('assets/images/bg_overlay_top.png',
                  fit: BoxFit.cover, height: 100, width: double.infinity),
              Container(
                padding: const EdgeInsets.only(top: 60),
                child: Lottie.asset(widget.animationFile,
                    width: 260,
                    height: 260,
                    frameRate: FrameRate.max,
                    controller: _controller,
                    onLoaded: (composition) => {
                          _controller
                            ..duration = composition.duration
                            ..forward()
                        }),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              widget.textTitle,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColor.orangeDark,
                  letterSpacing: 1.2),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Text(
              widget.textSubTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 1.1,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppColor.grayText),
            ),
          ),
          Visibility(
              visible: widget.visibleButton,
              child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      locator.get<PrefHelper>().setOnBoardingStatus(true);
                      Route route = MaterialPageRoute(
                          builder: (context) => const HomePage());
                      Navigator.pushReplacement(context, route);
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200.0),
                        )),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColor.orangeDark)),
                    child: const Text("Bắt đầu trải nghiệm"),
                  )))
        ],
      ),
    );
  }
}
