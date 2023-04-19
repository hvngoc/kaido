import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/view/label_text.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class BoxInputWithValidation extends StatelessWidget {
  final String title;
  final String hint;
  final bool isError;
  final String errorMessage;
  final ValueChanged<String>? onChanged;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const BoxInputWithValidation(
      {Key? key,
      required this.title,
      required this.isError,
      required this.errorMessage,
      required this.hint,
      this.keyboardType,
      this.textInputAction,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: isError ? AppColor.orangeDark : AppColor.grayD7,
        width: 1,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: LabelText(label: title),
        ),
        TextField(
          cursorColor: AppColor.orangeDark,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: border,
            errorBorder: border,
            focusedBorder: border,
            focusedErrorBorder: border,
            enabledBorder: border,
            contentPadding: EdgeInsets.all(8),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.black_40p,
            ),
            errorText: isError ? errorMessage : null,
            errorStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColor.orangeDark,
            ),
          ),
        ),
      ],
    );
  }
}
