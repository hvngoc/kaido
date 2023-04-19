import 'package:flutter/material.dart';

class OutlinedBorderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color color;

  OutlinedBorderButton({
    required this.onPressed,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 14,
          right: 14,
        ),
        backgroundColor: Colors.white,
        side: BorderSide(
          width: 1,
          color: color,
        ),
      ),
    );
  }
}
