import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:propzy_home/src/presentation/ui/search/filter_project/filter_price_suggestion_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/number_to_vietnamese.dart';

class FieldTextPrice extends StatefulWidget {
  final String? titleHeader;
  final String? hint;
  final String? lastValue;
  final String unit;

  final String? initValue;

  final bool allowZero;

  final Function(int?) onChange;

  const FieldTextPrice({
    Key? key,
    this.titleHeader,
    this.hint,
    required this.unit,
    required this.onChange,
    this.initValue,
    this.lastValue,
    this.allowZero = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextPrice();
}

class _TextPrice extends State<FieldTextPrice> {
  final FocusNode _fromNode = FocusNode();
  late final TextEditingController _fromController;

  String? textVietnamese = '';

  @override
  void didUpdateWidget(FieldTextPrice oldWidget) {
    if (widget.initValue != null && oldWidget.initValue == null) {
      _onTextChanged(widget.initValue ?? '', force: false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController(text: widget.lastValue);
  }

  @override
  void dispose() {
    _fromController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = [
      FilteringTextInputFormatter.deny(
        RegExp('[-|\.|,|\ ]'),
      ),
      LengthLimitingTextInputFormatter(15),
    ];
    if (!widget.allowZero) {
      formatter.add(
        FilteringTextInputFormatter.deny(
          RegExp(r'^0+'),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.titleHeader != null,
          child: Text(
            widget.titleHeader ?? '',
            style: TextStyle(
              color: AppColor.secondaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Visibility(
          visible: widget.titleHeader != null,
          child: SizedBox(height: 8),
        ),
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              width: 1,
              color: AppColor.grayC6,
            ),
          ),
          child: Container(
            height: 50,
            child: KeyboardActions(
              disableScroll: true,
              config: _buildConfig(context),
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      inputFormatters: formatter,
                      controller: _fromController,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      focusNode: _fromNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hint,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        counterText: "",
                      ),
                      onChanged: (String text) {
                        _onTextChanged(text);
                      },
                    ),
                  ),
                  Visibility(
                    visible: textVietnamese?.isNotEmpty == true,
                    child: InkResponse(
                      radius: 24,
                      onTap: () {
                        _fromController.text = '';
                        _updateUI(null);
                      },
                      child: SvgPicture.asset('assets/images/vector_ic_close_input_price.svg'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColor.grayF4,
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                    ),
                    child: Text(
                      widget.unit,
                      style: TextStyle(
                        color: AppColor.gray400_ibuy,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        backgroundColor: AppColor.grayF4,
                      ),
                    ),
                    alignment: Alignment.center,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 6),
        Visibility(
          visible: textVietnamese?.isNotEmpty == true,
          child: Text(
            textVietnamese ?? '',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.gray600,
            ),
          ),
        ),
      ],
    );
  }

  void _onTextChanged(String text, {bool force = true}) {
    final valueString = text.replaceAll('.', '');
    final valueInt = int.tryParse(valueString);
    if (valueInt != null) {
      final f = NumberFormat.currency(locale: "vi_VN", symbol: "");
      _fromController.text = f.format(valueInt).trim();
      _fromController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: _fromController.text.length,
        ),
      );
      _updateUI(valueInt, force: force);
    } else {
      _updateUI(null);
    }
  }

  void _updateUI(int? value, {bool force = true}) {
    textVietnamese = value != null ? NumberToVietnamese.convert(value) : null;
    if (force) {
      widget.onChange(value);
      setState(() {});
    }
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
                  onSuggestion: (text) {
                    _onTextChanged(text);
                  },
                ),
              ),
            ),
            preferredSize: Size.fromHeight(48),
          ),
        ),
      ],
    );
  }
}
