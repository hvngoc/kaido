import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FieldCheckboxItem extends StatelessWidget {
  const FieldCheckboxItem({
    Key? key,
    required this.title,
    required this.isSelected,
    this.onPress,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        children: [
          SvgPicture.asset(
            isSelected ? 'assets/images/checkbox_selected.svg' : 'assets/images/checkbox_normal.svg',
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
