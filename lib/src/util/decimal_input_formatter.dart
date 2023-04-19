import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(".", ",");
    if (text.contains(",")) {
      if (text.allMatches(",").length > 1) {
        text = text.substring(0, text.length - 1);
      }

      if (text.length == 1) {
        text = "0,";
      } else {
        final textArr = text.split(",");
        var textAfterDot = textArr[1];
        if (textAfterDot.length > 2) {
          textAfterDot = textAfterDot.substring(0, 2);
        }

        text = "${textArr[0]},${textAfterDot}";
      }
    }
    return newValue.copyWith(
      text: text,
      selection: new TextSelection.collapsed(offset: text.length),
    );
  }
}
