import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class CreateListingProgressBarView extends StatelessWidget {
  const CreateListingProgressBarView({
    Key? key,
    this.currentStep = 1,
    this.currentScreenInStep = 1,
    this.totalScreensInStep = 1,
    this.padding = 30,
    this.parentPadding = 0,
  }) : super(key: key);

  final int currentStep;
  final int currentScreenInStep;
  final int totalScreensInStep;
  final double padding;
  final double parentPadding;

  ProgressNodeState _stateOfNode(int index) {
    if (currentStep > index) {
      return ProgressNodeState.done;
    }
    if (currentStep == index) {
      return ProgressNodeState.inProcess;
    }
    return ProgressNodeState.none;
  }

  double _percentOfProgressBar(
    int index,
  ) {
    if (currentStep > index) {
      return 1.0;
    }
    if (currentStep == index) {
      return (currentScreenInStep - 1) / totalScreensInStep;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final widthChildProgressView =
        (MediaQuery.of(context).size.width - 2 * (padding + parentPadding) - 4 * 40) / 3;
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: padding),
      height: 40,
      child: Row(
        children: [
          ProgressNodeView(
            text: "1",
            state: _stateOfNode(1),
          ),
          ChildProgressBarView(
            percent: _percentOfProgressBar(1),
            width: widthChildProgressView,
          ),
          ProgressNodeView(
            text: "2",
            state: _stateOfNode(2),
          ),
          ChildProgressBarView(
            percent: _percentOfProgressBar(2),
            width: widthChildProgressView,
          ),
          ProgressNodeView(
            text: "3",
            state: _stateOfNode(3),
          ),
          ChildProgressBarView(
            percent: _percentOfProgressBar(3),
            width: widthChildProgressView,
          ),
          ProgressNodeView(
            text: "4",
            state: _stateOfNode(4),
          ),
        ],
      ),
    );
  }
}

class ChildProgressBarView extends StatelessWidget {
  const ChildProgressBarView({
    Key? key,
    this.percent = 0,
    this.width = 100,
  }) : super(key: key);

  final double percent;
  final double width;

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: width,
      lineHeight: 10,
      percent: percent,
      barRadius: Radius.circular(5),
      backgroundColor: AppColor.gray_progress_node,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment(0, 0),
        stops: [0.0, 0.5, 0.5, 1],
        colors: [
          Color(0xFFFF8000),
          Color(0xFFFF8000),
          Color(0xFFFFBC48),
          Color(0xFFFFBC48),
        ],
        tileMode: TileMode.repeated,
      ),
    );
  }
}

enum ProgressNodeState { none, inProcess, done }

class ProgressNodeView extends StatelessWidget {
  const ProgressNodeView({
    Key? key,
    required this.text,
    this.widthNode = 40,
    this.state = ProgressNodeState.none,
  }) : super(key: key);

  final String text;
  final double widthNode;
  final ProgressNodeState state;

  @override
  Widget build(BuildContext context) {
    final textColor = state == ProgressNodeState.done
        ? Colors.white
        : (state == ProgressNodeState.inProcess ? AppColor.orangeDark : Colors.black);
    final bgColor =
        state == ProgressNodeState.done ? AppColor.orangeDark : AppColor.gray_progress_node;
    final double borderWidth = state == ProgressNodeState.inProcess ? 1.0 : 0.0;
    final borderColor =
        state == ProgressNodeState.inProcess ? AppColor.orangeDark : AppColor.gray_progress_node;
    return Container(
      height: widthNode,
      width: widthNode,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
