import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';

class SelectDateTime {
  final DateTime dateTime;
  bool isSelected;

  SelectDateTime({
    required this.dateTime,
    this.isSelected = false,
  });
}

class SelectBookDateTimeView extends StatefulWidget {
  const SelectBookDateTimeView({Key? key}) : super(key: key);

  @override
  State<SelectBookDateTimeView> createState() => _SelectBookDateTimeViewState();
}

class _SelectBookDateTimeViewState extends State<SelectBookDateTimeView> {
  final List<SelectDateTime> listDate = [];
  final List<SelectDateTime> listTime = [];

  @override
  void initState() {
    super.initState();

    final currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime startTime;
    if (currentDate.isBefore(startDate.add(Duration(hours: 20)))) {
      if (currentDate.hour < 7) {
        startTime = DateTime(0, 1, 1, 7, 0);
      } else {
        if (currentDate.minute < 30) {
          startTime = DateTime(0, 1, 1, currentDate.hour, 30);
        } else {
          startTime = DateTime(0, 1, 1, currentDate.hour + 1, 0);
        }
      }
    } else {
      startDate = startDate.add(Duration(days: 1));
      startTime = DateTime(0, 1, 1, 7, 0);
    }

    loadListDate(startDate);
    loadListTime(startTime);
  }

  DateTime _getStartTime(DateTime dateTime) {
    DateTime startTime;
    final currentDate = DateTime.now();
    if (currentDate.day == dateTime.day) {
      if (currentDate.hour < 7) {
        startTime = DateTime(0, 1, 1, 7, 0);
      } else {
        if (currentDate.minute < 30) {
          startTime = DateTime(0, 1, 1, currentDate.hour, 30);
        } else {
          startTime = DateTime(0, 1, 1, currentDate.hour + 1, 0);
        }
      }
    } else {
      startTime = DateTime(0, 1, 1, 7, 0);
    }
    return startTime;
  }

  void loadListDate(DateTime startDate) {
    listDate.removeRange(0, listDate.length);
    for (int i = 0; i < 14; i++) {
      listDate.add(
        SelectDateTime(
          dateTime: startDate.add(Duration(days: i)),
          isSelected: i == 0 ? true : false,
        ),
      );
    }
  }

  void loadListTime(DateTime startTime) {
    listTime.removeRange(0, listTime.length);
    DateTime endTime = DateTime(0, 1, 1, 20, 01);
    while (startTime.isBefore(endTime)) {
      listTime.add(SelectDateTime(
        dateTime: startTime,
        isSelected: listTime.length == 0 ? true : false,
      ));
      startTime = startTime.add(Duration(minutes: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Color(0xFFEFF3F4),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final dateItem = listDate[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  child: SelectDateView(
                    selectDateTime: dateItem,
                    onTapCallback: (selectDateTime) {
                      final startTime = _getStartTime(selectDateTime.dateTime);
                      setState(() {
                        listDate.forEach((e) {
                          if (selectDateTime.dateTime
                              .isAtSameMomentAs(e.dateTime)) {
                            e.isSelected = true;
                          } else {
                            e.isSelected = false;
                          }
                        });

                        loadListTime(startTime);
                      });
                    },
                  ),
                );
              },
              itemCount: listDate.length,
            ),
          ),
          Container(
            height: 0.2,
            decoration: BoxDecoration(
              color: Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  // spreadRadius: 1,
                  blurRadius: 6,
                  // offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final timeItem = listTime[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  child: SelectTimeView(
                    selectDateTime: timeItem,
                    onTapCallback: (selectDateTime) {
                      setState(() {
                        listTime.forEach((e) {
                          if (selectDateTime.dateTime
                              .isAtSameMomentAs(e.dateTime)) {
                            e.isSelected = true;
                          } else {
                            e.isSelected = false;
                          }
                        });
                      });
                    },
                  ),
                );
              },
              itemCount: listTime.length,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectDateView extends StatelessWidget {
  const SelectDateView(
      {Key? key, required this.selectDateTime, this.onTapCallback})
      : super(key: key);

  final SelectDateTime selectDateTime;
  final Function(SelectDateTime)? onTapCallback;

  @override
  Widget build(BuildContext context) {
    final dateTime = selectDateTime.dateTime;
    final isSelected = selectDateTime.isSelected;
    final textColor = isSelected ? Colors.white : Colors.black;
    return InkWell(
      onTap: () {
        if (onTapCallback != null) {
          onTapCallback!(selectDateTime);
        }
      },
      child: Container(
        height: 90,
        width: 80,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.orangeDark : Colors.white,
          border: Border.all(
              width: 1,
              color: isSelected ? AppColor.orangeDark : AppColor.grayD8),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${Constants.LIST_DATE_OF_WEEK_STRING[dateTime.weekday - 1].toUpperCase()}',
              style: TextStyle(color: textColor, fontSize: 12),
            ),
            Text('${dateTime.day}',
                style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700)),
            Text('Tháng ${dateTime.month}',
                style: TextStyle(color: textColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class SelectTimeView extends StatelessWidget {
  const SelectTimeView(
      {Key? key, required this.selectDateTime, this.onTapCallback})
      : super(key: key);

  final SelectDateTime selectDateTime;
  final Function(SelectDateTime)? onTapCallback;

  @override
  Widget build(BuildContext context) {
    final dateTime = selectDateTime.dateTime;
    final isSelected = selectDateTime.isSelected;
    final textColor = isSelected ? Colors.white : Colors.black;
    DateFormat dateFormat = DateFormat("HH:mm");
    return InkWell(
      onTap: () {
        if (onTapCallback != null) {
          onTapCallback!(selectDateTime);
        }
      },
      child: Container(
        height: 40,
        width: 80,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.orangeDark : Colors.white,
          border: Border.all(
              width: 1,
              color: isSelected ? AppColor.orangeDark : AppColor.grayD8),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: SvgPicture.asset('assets/images/ic_clock.svg',
                  color: textColor),
            ),
            SizedBox(width: 4),
            Text(
              '${dateFormat.format(dateTime)}',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
