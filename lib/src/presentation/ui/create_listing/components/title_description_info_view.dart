import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class TitleDescriptionInfoView extends StatelessWidget {
  const TitleDescriptionInfoView({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColor.gray400_ibuy),
          ),
        ],
      ),
    );
  }
}
