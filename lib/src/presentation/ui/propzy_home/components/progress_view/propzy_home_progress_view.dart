import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class PropzyHomeProgressView extends StatelessWidget {
  const PropzyHomeProgressView({
    Key? key,
    this.totalPercent = 50,
  }) : super(key: key);

  final double totalPercent;

  @override
  Widget build(BuildContext context) {
    final widthContainer = MediaQuery.of(context).size.width - 100;
    final widthLinearProgress = widthContainer - 30 - 10;
    final leftTooltip = (widthLinearProgress * totalPercent / 100) + 20 - 18;
    return Container(
      height: 70,
      width: widthContainer,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned(
            left: leftTooltip,
            bottom: 30,
            child: Stack(
              children: [
                Container(
                  width: 36,
                  height: 32,
                  child: SvgPicture.asset(
                    'assets/images/ic_iBuyer_progress_tooltip.svg',
                    alignment: Alignment.topLeft,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  top: 2, left: totalPercent >= 100 ? 2 : 5,
                  child: Text(
                    '${totalPercent.toInt()}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 13,
                  ),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: totalPercent / 100,
                    color: AppColor.orangeDark,
                    backgroundColor: AppColor.grayCC,
                  ),
                ),
                Row(
                  children: [
                    StepIconView(
                      iconName: 'assets/images/ic_iBuyer_progress_step_1.svg',
                    ),
                    StepIconView(
                      iconName: 'assets/images/ic_iBuyer_progress_step_5.svg',
                      isSelected: totalPercent >= 100 / 3,
                    ),
                    StepIconView(
                      iconName: 'assets/images/ic_iBuyer_progress_step_6.svg',
                      isSelected: totalPercent >= 200 / 3,
                    ),
                    StepIconView(
                      iconName: 'assets/images/ic_iBuyer_progress_step_3.svg',
                      isSelected: totalPercent >= 100,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepIconView extends StatelessWidget {
  const StepIconView({
    Key? key,
    required this.iconName,
    this.iconWidth = 17,
    this.isSelected = true,
  }) : super(key: key);

  final String iconName;
  final double iconWidth;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: isSelected ? AppColor.orangeDark : AppColor.grayCC,
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          iconName,
          width: iconWidth,
          height: iconWidth,
          color: isSelected ? AppColor.orangeDark : AppColor.grayCC,
        ),
      ),
    );
  }
}
