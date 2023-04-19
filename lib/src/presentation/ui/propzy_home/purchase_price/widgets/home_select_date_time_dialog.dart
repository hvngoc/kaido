import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/view/home_select_date_time_view.dart';

class HomeSelectDateTimeDialog extends StatefulWidget {
  const HomeSelectDateTimeDialog({
    Key? key,
    this.onPressSelect,
  }) : super(key: key);

  final void Function(DateTime dateTime)? onPressSelect;

  @override
  State<HomeSelectDateTimeDialog> createState() =>
      _HomeSelectDateTimeDialogState();
}

class _HomeSelectDateTimeDialogState extends State<HomeSelectDateTimeDialog> {
  DateTime currentSelect = DateTime.now().add(Duration(hours: 2));

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy - HH:mm');
    final selectString = formatter.format(currentSelect);
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Đóng',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Spacer(),
                Text(selectString),
                Spacer(),
                SizedBox(width: 40),
              ],
            ),
          ),
          Divider(height: 1),
          HomeSelectDateTimeView(
            dateChanged: (dateTime) {
              setState(() {
                currentSelect = dateTime;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: OrangeButton(
              title: 'Chọn',
              onPressed: () {
                if (widget.onPressSelect != null) {
                  widget.onPressSelect!(currentSelect);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
