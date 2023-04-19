import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:propzy_home/src/util/number_to_vietnamese.dart';
import 'filter_price_suggestion_view.dart';

class FilterProjectInputPriceView extends StatefulWidget {
  FilterProjectInputPriceView({
    Key? key,
    this.onEndEditing,
    this.minPrice,
    this.maxPrice
  }) : super(key: key);

  final void Function(String, String)? onEndEditing;
  final double? minPrice;
  final double? maxPrice;


  @override
  State<FilterProjectInputPriceView> createState() =>
      FilterProjectInputPriceViewState();
}

class FilterProjectInputPriceViewState extends State<FilterProjectInputPriceView> {
  final FocusNode _fromNode = FocusNode();
  final FocusNode _toNode = FocusNode();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  late StreamSubscription<bool> keyboardSubscription;
  bool _hasFocus = false;

  Timer? _debounceFrom;
  Timer? _debounceTo;
  static const int DEBOUNCE_MILLISECONDS = 500;

  @override
  void initState() {
    super.initState();
    if(widget.minPrice != null){
      _fromController.text = NumberToVietnamese.formatNumber(widget.minPrice)!;
    }
    if(widget.maxPrice != null){
      _toController.text = NumberToVietnamese.formatNumber(widget.maxPrice)!;
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

  void callCallback([bool isReplaceValue = false]) {
    String _minText = _fromController.text;
    String _maxText = _toController.text;
    if (_fromController.text.length != 0 && _toController.text.length != 0) {
      final minPrice =
          double.tryParse(_fromController.text.replaceAll('.', '')) ?? -1.0;
      final maxPrice =
          double.tryParse(_toController.text.replaceAll('.', '')) ?? -1.0;
      if (minPrice != -1.0 && maxPrice != -1.0 && minPrice > maxPrice) {
        _minText = _toController.text;
        _maxText = _fromController.text;
        if (isReplaceValue) {
          _fromController.text = _minText;
          _toController.text = _maxText;
        }
      }
    }

    if (widget.onEndEditing != null) {
      widget.onEndEditing!(_minText, _maxText);
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();

    keyboardSubscription.cancel();
    super.dispose();
  }

  void resetInput(){
    _fromController.clear();
    _toController.clear();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          displayActionBar: false,
          displayDoneButton: false,
          focusNode: _fromNode,
          footerBuilder: (_) => PreferredSize(
            child: SizedBox(
              height: 48,
              child: Center(
                child: FilterPriceSuggestionView(
                  focusNode: _fromNode,
                  textController: _fromController,
                ),
              ),
            ),
            preferredSize: Size.fromHeight(48),
          ),
        ),
        KeyboardActionsItem(
          displayActionBar: false,
          displayDoneButton: false,
          focusNode: _toNode,
          footerBuilder: (_) => PreferredSize(
            child: SizedBox(
              height: 48,
              child: Center(
                child: FilterPriceSuggestionView(
                  focusNode: _toNode,
                  textController: _toController,
                ),
              ),
            ),
            preferredSize: Size.fromHeight(48),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: KeyboardActions(
        disableScroll: true,
        config: _buildConfig(context),
        tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp('[-|\.|,|\ ]'),
                  )
                ],
                onTap: () {
                  _hasFocus = true;
                },
                controller: _fromController,
                keyboardType: TextInputType.number,
                focusNode: _fromNode,
                maxLength: 12,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Giá từ",
                  contentPadding: const EdgeInsets.all(8),
                  counterText: "",
                ),
                onChanged: (String text) {
                  final valueString = text.replaceAll('.', '');
                  final valueInt = int.tryParse(valueString);
                  if (valueInt != null) {
                    final f =
                        NumberFormat.currency(locale: "vi_VN", symbol: "");
                    _fromController.text = f.format(valueInt).trim();
                    _fromController.selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: _fromController.text.length,
                      ),
                    );
                  }

                  if (_debounceFrom?.isActive ?? false) _debounceFrom?.cancel();
                  _debounceFrom =
                      Timer(Duration(milliseconds: DEBOUNCE_MILLISECONDS), () {
                    callCallback();
                  });
                },
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
                    RegExp('[-|\.|,|\ ]'),
                  )
                ],
                onTap: () {
                  _hasFocus = true;
                },
                controller: _toController,
                keyboardType: TextInputType.number,
                focusNode: _toNode,
                maxLength: 12,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Giá đến",
                  contentPadding: const EdgeInsets.all(8),
                  counterText: "",
                ),
                onChanged: (String text) {
                  final valueString = text.replaceAll('.', '');
                  final valueInt = int.tryParse(valueString);
                  if (valueInt != null) {
                    final f =
                        NumberFormat.currency(locale: "vi_VN", symbol: "");
                    _toController.text = f.format(valueInt).trim();
                    _toController.selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: _toController.text.length,
                      ),
                    );
                  }

                  if (_debounceTo?.isActive ?? false) _debounceTo?.cancel();
                  _debounceTo =
                      Timer(Duration(milliseconds: DEBOUNCE_MILLISECONDS), () {
                    callCallback();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
