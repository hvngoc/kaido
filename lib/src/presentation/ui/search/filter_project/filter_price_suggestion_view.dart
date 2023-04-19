import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterPriceSuggestionView extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textController;
  final Function(String text)? onSuggestion;

  FilterPriceSuggestionView({
    Key? key,
    required this.focusNode,
    required this.textController,
    this.onSuggestion
  }) : super(key: key);

  final List<int> arrPriceSuggestion = [
    1000000,
    10000000,
    100000000,
    1000000000
  ];

  @override
  State<FilterPriceSuggestionView> createState() =>
      _FilterPriceSuggestionViewState();
}

class _FilterPriceSuggestionViewState extends State<FilterPriceSuggestionView> {
  late String _myText;

  @override
  void initState() {
    super.initState();
    _myText = convertStringDecimalToInt(widget.textController.text);
    widget.textController.addListener(() {
      if (this.mounted) {
        setState(() {
          _myText = convertStringDecimalToInt(widget.textController.text);
        });
      }
    });
    widget.focusNode.addListener(() {
      if (this.mounted && widget.focusNode.hasFocus) {
        setState(() {
          _myText = convertStringDecimalToInt(widget.textController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    widget.textController.removeListener(() {});
    widget.focusNode.removeListener(() {});
    super.dispose();
  }

  String convertStringDecimalToInt(String decimalString) {
    return decimalString.replaceAll('.', '');
  }

  String formatPriceInDecimal(int price) {
    final f = NumberFormat.currency(locale: "vi_VN", symbol: "");
    return f.format(price).trim();
  }

  double roundDouble(double value) {
    double mod = 100;
    return ((value * mod).floorToDouble() / mod);
  }

  String formatPriceInSuggest(int price) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    if (price >= 1000000000) {
      final numBillion = price / 1000000000;
      final formatStr = roundDouble(numBillion)
          .toString()
          .replaceAll(regex, '')
          .replaceAll('.', ',');
      return '${formatStr} tỷ';
    } else {
      final numMillion = price / 1000000;
      return '${numMillion.toInt()} triệu';
    }
  }

  List<Widget> _buildList(String text) {
    final number = int.tryParse(text) ?? 0;
    if (number > 0 && number < 1000000) {
      List<int> arrSug = [];
      for (int priceSug in widget.arrPriceSuggestion) {
        final tmpValue = number * priceSug;
        if (tmpValue < 1000000000000) {
          arrSug.add(tmpValue);
        } else {
          arrSug.add(0);
        }
      }
      return arrSug
          .map((e) => e != 0
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xFFE8EFF6),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                      ),
                      child: Text(
                        formatPriceInSuggest(e),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        widget.textController.text =
                            '${formatPriceInDecimal(e)}';
                        widget.textController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                            offset: widget.textController.text.length,
                          ),
                        );
                        widget.focusNode.unfocus();
                        if (widget.onSuggestion != null) {
                          widget.onSuggestion!(widget.textController.text);
                        }
                      },
                    ),
                  ),
                )
              : Expanded(child: Container()))
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildList(_myText),
      ),
    );
  }
}
