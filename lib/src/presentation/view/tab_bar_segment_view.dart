import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/app_colors.dart';

class TabBarSegmentView extends StatefulWidget {
  TabBarSegmentView({Key? key, required this.onTabChange, required this.startOffset})  : super(key: key);

  final Function onTabChange;
  final int startOffset;

  @override
  State<TabBarSegmentView> createState() => TabBarSegmentViewState();
}

class TabBarSegmentViewState extends State<TabBarSegmentView> {
  int segmentedControlGroupValue = 0;

  final Map<int, Widget> myTabs = const <int, Widget>{};

  @override
  void initState() {
    segmentedControlGroupValue = widget.startOffset;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: CupertinoSlidingSegmentedControl(
        groupValue: segmentedControlGroupValue,
        children: <int, Widget>{
          0: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Mua',
              style: getColor(0),
            ),
          ),
          1: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Thuê',
              style: getColor(1),
            ),
          ),
          2: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Dự Án',
              style: getColor(2),
            ),
          ),
        },
        thumbColor: AppColor.propzyOrange,
        backgroundColor: HexColor('#F3F3F3'),
        onValueChanged: (int? value) {
          widget.onTabChange(value);
          setState(() {
            segmentedControlGroupValue = value!;
          });
        },
      ),
    );
  }

  TextStyle getColor(index) {
    var color = segmentedControlGroupValue == index ? Colors.white : HexColor(
        '242933');
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }
}