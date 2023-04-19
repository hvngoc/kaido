import 'package:flutter/material.dart';

class BoldSectionTitle extends StatelessWidget {
  const BoldSectionTitle({
    Key? key,
    required this.text,
    this.displayStar = true,
    this.paddingLeft = 16,
  }) : super(key: key);

  final String text;
  final bool displayStar;
  final double? paddingLeft;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: paddingLeft),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Visibility(
          visible: displayStar,
          child: Text(
            ' *',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }
}
