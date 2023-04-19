import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class FieldTextInput extends StatelessWidget {
  final String title;
  final double childWidth;
  final String unit;

  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? textEditingController;
  final CrossAxisAlignment? crossAxisAlignment;
  final bool isFixFieldSize;
  final int? maxLength;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? unitStyle;

  const FieldTextInput({
    Key? key,
    required this.title,
    required this.childWidth,
    required this.unit,
    required this.hint,
    this.onChanged,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.inputFormatters,
    this.textEditingController,
    this.crossAxisAlignment,
    this.isFixFieldSize = true,
    this.maxLength,
    this.style,
    this.hintStyle,
    this.unitStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          isFixFieldSize
              ? Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColor.blackDefault,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                    color: AppColor.blackDefault,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          SizedBox(width: 8),
          Container(
            height: 48,
            width: childWidth,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColor.grayC6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: style ??
                        TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackDefault,
                        ),
                    cursorColor: AppColor.orangeDark,
                    textInputAction: TextInputAction.done,
                    keyboardType: keyboardType,
                    onChanged: onChanged,
                    inputFormatters: inputFormatters,
                    controller: textEditingController,
                    maxLength: maxLength,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      hintStyle: hintStyle ??
                          TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.secondaryText,
                          ),
                    ),
                  ),
                ),
                Visibility(
                  visible: unit.isNotEmpty,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.grayF4,
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(4)),
                    ),
                    child: Text(
                      unit,
                      style: unitStyle ??
                          TextStyle(
                            color: AppColor.gray400_ibuy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            backgroundColor: AppColor.grayF4,
                          ),
                    ),
                    alignment: Alignment.center,
                    width: 40,
                    height: 48,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
