import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';

import 'package:propzy_home/src/util/number_to_vietnamese.dart';

class FilterProjectInputView extends StatefulWidget {
  final String fromPlaceHolder;
  final String toPlaceHolder;
  final double? fromText;
  final double? toText;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool isDisplayUnit;
  final void Function(String, String)? onEndEditing;

  const FilterProjectInputView({
    Key? key,
    this.fromPlaceHolder = "",
    this.toPlaceHolder = "",
    this.keyboardType = TextInputType.number,
    this.maxLength = null,
    this.isDisplayUnit = false,
    this.onEndEditing,
    this.fromText,
    this.toText
  }) : super(key: key);

  @override
  State<FilterProjectInputView> createState() => FilterProjectInputViewState();
}

class FilterProjectInputViewState extends State<FilterProjectInputView> {
  late StreamSubscription<bool> keyboardSubscription;
  bool _hasFocus = false;
  final TextEditingController _fromTextController = TextEditingController();
  final TextEditingController _toTextController = TextEditingController();
  Timer? _debounceFrom;
  Timer? _debounceTo;
  static const int DEBOUNCE_MILLISECONDS = 500;


  @override
  void initState() {
    super.initState();

    if(widget.fromText != null){
      _fromTextController.text = NumberToVietnamese.formatNumber(widget.fromText)!;
    }

    if(widget.toText != null){
      _toTextController.text = NumberToVietnamese.formatNumber(widget.toText)!;
    }

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        if (_hasFocus) {
          _hasFocus = false;
          callCallback(true);
        }
      }
    });
  }

  void resetFilter(){
    _fromTextController.clear();
    _toTextController.clear();
  }

  void callCallback([bool isReplaceValue = false]) {
    String _minText = _fromTextController.text;
    String _maxText = _toTextController.text;
    if (_fromTextController.text.length != 0 &&
        _toTextController.text.length != 0) {
      final minValue =
          double.tryParse(_fromTextController.text.replaceAll(',', '.')) ??
              -1.0;
      final maxValue =
          double.tryParse(_toTextController.text.replaceAll(',', '.')) ?? -1.0;
      if (minValue != -1.0 && maxValue != -1.0 && minValue > maxValue) {
        _minText = _toTextController.text;
        _maxText = _fromTextController.text;
        if (isReplaceValue) {
          _fromTextController.text = _minText;
          _toTextController.text = _maxText;
        }
      }
    }

    if (widget.onEndEditing != null) {
      widget.onEndEditing!(_minText, _maxText);
    }
  }

  @override
  void dispose() {
    _fromTextController.dispose();
    _toTextController.dispose();

    keyboardSubscription.cancel();
    _debounceFrom?.cancel();
    _debounceTo?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                widget.isDisplayUnit ? RegExp('[-|\ ]') : RegExp('[-|\.|,|\ ]'),
              ),
            ],
            controller: _fromTextController,
            onTap: () {
              _hasFocus = true;
            },
            onChanged: (newText) {
              if (widget.isDisplayUnit) {
                String text = newText.replaceAll('.', ',');
                int firstIndex = text.indexOf(',');
                if (firstIndex != -1) {
                  text = text.replaceFirst(',', '', firstIndex + 1);
                }
                _fromTextController.text = text;
                _fromTextController.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: _fromTextController.text.length,
                  ),
                );
              } else {
                if (newText == '0') {
                  _fromTextController.text = '';
                }
              }

              if (_debounceFrom?.isActive ?? false) _debounceFrom?.cancel();
              _debounceFrom = Timer(
                  const Duration(milliseconds: DEBOUNCE_MILLISECONDS), () {
                callCallback();
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: widget.fromPlaceHolder,
              contentPadding: EdgeInsets.all(8),
              counterText: "",
              suffixIcon: widget.isDisplayUnit
                  ? Container(
                      margin: EdgeInsets.all(2),
                      width: 20,
                      decoration: BoxDecoration(
                        color: AppColor.grayF4,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: IntrinsicHeight(
                        child: Center(
                          child: Text(
                            'm²',
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
          ),
        ),
        Container(
          width: 30,
          child: Text(
            '-',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                widget.isDisplayUnit ? RegExp('[-|\ ]') : RegExp('[-|\.|,|\ ]'),
              )
            ],
            controller: _toTextController,
            onTap: () {
              _hasFocus = true;
            },
            onChanged: (newText) {
              if (widget.isDisplayUnit) {
                String text = newText.replaceAll('.', ',');
                int firstIndex = text.indexOf(',');
                if (firstIndex != -1) {
                  text = text.replaceFirst(',', '', firstIndex + 1);
                }
                _toTextController.text = text;
                _toTextController.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: _toTextController.text.length,
                  ),
                );
              } else {
                if (newText == '0') {
                  _toTextController.text = '';
                }
              }

              if (_debounceTo?.isActive ?? false) _debounceTo?.cancel();
              _debounceTo = Timer(
                  const Duration(milliseconds: DEBOUNCE_MILLISECONDS), () {
                callCallback();
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: widget.toPlaceHolder,
              contentPadding: EdgeInsets.all(8),
              counterText: "",
              suffixIcon: widget.isDisplayUnit
                  ? Container(
                      margin: EdgeInsets.all(2),
                      width: 20,
                      decoration: BoxDecoration(
                        color: AppColor.grayF4,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: IntrinsicHeight(
                        child: Center(
                          child: Text(
                            'm²',
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
          ),
        ),
      ],
    );
  }
}
