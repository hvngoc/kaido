import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/view/select_book_date_time_view.dart';

class HomeSelectDateTimeView extends StatefulWidget {
  const HomeSelectDateTimeView({
    Key? key,
    this.dateChanged,
  }) : super(key: key);

  final void Function(DateTime dateTime)? dateChanged;

  @override
  State<HomeSelectDateTimeView> createState() => _HomeSelectDateTimeViewState();
}

class _HomeSelectDateTimeViewState extends State<HomeSelectDateTimeView> {
  static final beginDateTime = DateTime.now().add(Duration(hours: 2));

  final List<SelectDateTime> listDate = [];
  DateTime currentSelected = beginDateTime;

  @override
  void initState() {
    super.initState();

    final currentDate = beginDateTime;
    DateTime startDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    loadListDate(startDate);
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

  Widget _rebuildTimePicker(DateTime selected) {
    final isBeginDate = DateTime(selected.year, selected.month, selected.day)
        .isAtSameMomentAs(DateTime(
            beginDateTime.year, beginDateTime.month, beginDateTime.day));
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      use24hFormat: true,
      backgroundColor: Colors.white,
      initialDateTime: beginDateTime,
      minimumDate: isBeginDate ? beginDateTime : null,
      onDateTimeChanged: (duration) {
        setState(() {
          currentSelected = DateTime(
            currentSelected.year,
            currentSelected.month,
            currentSelected.day,
            duration.hour,
            duration.minute,
          );
        });
        // print(currentSelected);
        if (widget.dateChanged != null) {
          widget.dateChanged!(currentSelected);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      final selected = selectDateTime.dateTime;
                      final isBeginDate =
                          DateTime(selected.year, selected.month, selected.day)
                              .isAtSameMomentAs(DateTime(beginDateTime.year,
                                  beginDateTime.month, beginDateTime.day));
                      setState(() {
                        listDate.forEach((e) {
                          if (selectDateTime.dateTime
                              .isAtSameMomentAs(e.dateTime)) {
                            e.isSelected = true;
                          } else {
                            e.isSelected = false;
                          }
                        });
                        currentSelected = DateTime(
                          selectDateTime.dateTime.year,
                          selectDateTime.dateTime.month,
                          selectDateTime.dateTime.day,
                          isBeginDate
                              ? beginDateTime.hour
                              : currentSelected.hour,
                          isBeginDate
                              ? beginDateTime.minute
                              : currentSelected.minute,
                        );
                        // print(currentSelected);
                        if (widget.dateChanged != null) {
                          widget.dateChanged!(currentSelected);
                        }
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
            height: 150,
            child: _rebuildTimePicker(currentSelected),
          ),
        ],
      ),
    );
  }
}
