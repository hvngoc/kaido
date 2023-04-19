import 'package:flutter/material.dart';

/// ref: https://medium.com/aubergine-solutions/create-an-onboarding-page-indicator-in-3-minutes-in-flutter-a2bd97ceeaff
class PagerDotIndicator extends StatelessWidget {
  const PagerDotIndicator(
      {Key? key,
      required this.listWidgets,
      this.controller,
      this.onPageChanged,
      required this.currentPageValue,
      this.indicatorSpacing = 5,
      this.indicatorMarginBottom = 24,
      this.indicatorNormalSize = 8,
      this.indicatorSelectedSize = 12,
      required this.indicatorNormalColor,
      required this.indicatorSelectedColor})
      : super(key: key);

  final List<Widget> listWidgets;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;
  final int currentPageValue;

  final double indicatorSpacing;
  final double indicatorMarginBottom;
  final Color indicatorNormalColor;
  final Color indicatorSelectedColor;
  final double indicatorNormalSize;
  final double indicatorSelectedSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        PageView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: listWidgets.length,
          onPageChanged: onPageChanged,
          controller: controller,
          itemBuilder: (context, index) {
            return listWidgets[index];
          },
        ),
        Visibility(
          visible: listWidgets.length != 1,
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: indicatorMarginBottom),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < listWidgets.length; i++)
                      if (i == currentPageValue) ...[_circleIndicator(true)] else
                        _circleIndicator(false),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _circleIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: indicatorSpacing),
      height: isActive ? indicatorSelectedSize : indicatorNormalSize,
      width: isActive ? indicatorSelectedSize : indicatorNormalSize,
      decoration: BoxDecoration(
          color: isActive ? indicatorSelectedColor : indicatorNormalColor,
          borderRadius: const BorderRadius.all(Radius.circular(50))),
    );
  }
}
