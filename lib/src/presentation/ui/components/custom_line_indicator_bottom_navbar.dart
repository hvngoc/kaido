import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/util/app_colors.dart';

enum IndicatorType { Top, Bottom }

class CustomLineIndicatorBottomNavbar extends StatelessWidget {
  final Color? backgroundColor;
  final List<CustomBottomBarItems> customBottomBarItems;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final double unselectedFontSize;
  final Color? splashColor;
  final int currentIndex;
  final bool enableLineIndicator;
  final double lineIndicatorWidth;
  final IndicatorType indicatorType;
  final Function(int) onTap;
  final double selectedFontSize;
  final double selectedIconSize;
  final double unselectedIconSize;
  final LinearGradient? gradient;

  const CustomLineIndicatorBottomNavbar({
    Key? key,
    this.backgroundColor,
    this.selectedColor,
    required this.customBottomBarItems,
    this.unSelectedColor,
    this.unselectedFontSize = 12,
    this.selectedFontSize = 12,
    this.selectedIconSize = 20,
    this.unselectedIconSize = 20,
    this.splashColor,
    this.currentIndex = 0,
    required this.onTap,
    this.enableLineIndicator = true,
    this.lineIndicatorWidth = 3,
    this.indicatorType = IndicatorType.Top,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarThemeData bottomTheme = BottomNavigationBarTheme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? bottomTheme.backgroundColor,
        gradient: gradient,
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < customBottomBarItems.length; i++) ...[
              Expanded(
                child: CustomLineIndicatorBottomNavbarItems(
                  selectedColor: selectedColor,
                  unSelectedColor: unSelectedColor,
                  iconPath: customBottomBarItems[i].iconPath,
                  label: customBottomBarItems[i].label,
                  unSelectedFontSize: unselectedFontSize,
                  selectedFontSize: selectedFontSize,
                  unselectedIconSize: unselectedIconSize,
                  selectedIconSize: selectedIconSize,
                  splashColor: splashColor,
                  currentIndex: currentIndex,
                  enableLineIndicator: enableLineIndicator,
                  lineIndicatorWidth: lineIndicatorWidth,
                  showBadge: customBottomBarItems[i].showBadge,
                  indicatorType: indicatorType,
                  index: i,
                  onTap: onTap,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class CustomBottomBarItems {
  final String iconPath;
  final String label;
  final bool showBadge;

  CustomBottomBarItems({
    required this.iconPath,
    required this.label,
    required this.showBadge,
  });
}

class CustomLineIndicatorBottomNavbarItems extends StatelessWidget {
  final String iconPath;
  final String? label;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final double unSelectedFontSize;
  final double selectedIconSize;
  final double unselectedIconSize;

  final double selectedFontSize;
  final Color? splashColor;
  final int? currentIndex;
  final int index;
  final Function(int) onTap;
  final bool enableLineIndicator;
  final bool showBadge;
  final double lineIndicatorWidth;
  final IndicatorType indicatorType;

  const CustomLineIndicatorBottomNavbarItems({
    Key? key,
    required this.iconPath,
    this.label,
    this.selectedColor,
    this.unSelectedColor,
    this.unSelectedFontSize = 12,
    this.selectedFontSize = 12,
    this.selectedIconSize = 20,
    this.unselectedIconSize = 20,
    this.splashColor,
    this.currentIndex,
    required this.onTap,
    required this.index,
    this.enableLineIndicator = true,
    this.showBadge = false,
    this.lineIndicatorWidth = 3,
    this.indicatorType = IndicatorType.Top,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarThemeData bottomTheme = BottomNavigationBarTheme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 7),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: splashColor ?? Theme.of(context).splashColor,
            onTap: () {
              onTap(index);
            },
            child: Container(
              decoration: BoxDecoration(
                border: enableLineIndicator
                    ? Border(
                        bottom: indicatorType == IndicatorType.Bottom
                            ? BorderSide(
                                color: currentIndex == index
                                    ? selectedColor ?? bottomTheme.selectedItemColor!
                                    : Colors.transparent,
                                width: lineIndicatorWidth,
                              )
                            : const BorderSide(color: Colors.transparent),
                        top: indicatorType == IndicatorType.Top
                            ? BorderSide(
                                color: currentIndex == index
                                    ? selectedColor ?? bottomTheme.selectedItemColor!
                                    : Colors.transparent,
                                width: lineIndicatorWidth,
                              )
                            : const BorderSide(color: Colors.transparent),
                      )
                    : null,
              ),
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              // width: 70,
              // height: 60,
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SvgPicture.asset(
                        iconPath,
                        color: currentIndex == index
                            ? selectedColor ?? bottomTheme.unselectedItemColor
                            : unSelectedColor,
                      ),
                      Visibility(
                          visible: showBadge,
                          child: Container(
                            height: 6,
                            margin: EdgeInsets.only(top: 3, right: 2),
                            width: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.red,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '$label',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: currentIndex == index ? selectedFontSize : unSelectedFontSize,
                      color: currentIndex == index
                          ? selectedColor ?? bottomTheme.unselectedItemColor
                          : unSelectedColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
