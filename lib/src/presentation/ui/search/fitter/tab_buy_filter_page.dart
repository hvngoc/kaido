import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/search/filter_project/filter_project_input_price_view.dart';
import 'package:propzy_home/src/presentation/ui/search/filter_project/filter_project_input_view.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bathroom/bathroom.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bedroom/bedroom.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/position/position.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/property/view/property_page.dart';
import 'package:propzy_home/src/presentation/view/label_text.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';

import 'advantage/advantage.dart';
import 'content/content.dart';
import 'direction/direction.dart';

class TabBuyFilterPage extends StatefulWidget {
  const TabBuyFilterPage({Key? key}) : super(key: key);

  @override
  State<TabBuyFilterPage> createState() => TabBuyFilterPageState();
}

class TabBuyFilterPageState extends State<TabBuyFilterPage> {
  bool _switchChecked = false;
  static final _filterPriceInput = new GlobalKey<FilterProjectInputPriceViewState>();
  static final _filterYearInput = new GlobalKey<FilterProjectInputViewState>();
  static final _filterSizeInput = new GlobalKey<FilterProjectInputViewState>();

  void resetInputFilter(){
    _filterPriceInput.currentState?.resetInput();
    _filterYearInput.currentState?.resetFilter();
    _filterSizeInput.currentState?.resetFilter();
    setState(() {
      _switchChecked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    _switchChecked = parentBloc.isCheckedRadiobutton();
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 8,
        left: 16,
        right: 16,
      ),
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelText(
                label: 'Loại hình BĐS',
              ),
              PropertyPage(
                categoryType: CategoryType.BUY, listingTypeId: CategoryType.BUY.type,
              ),
              SizedBox(
                height: 16,
              ),
              LabelText(
                label: 'Giá',
              ),
              FilterProjectInputPriceView(
                key: _filterPriceInput,
                minPrice: parentBloc.categorySearchRequest.minPrice,
                maxPrice: parentBloc.categorySearchRequest.maxPrice,
                onEndEditing: (fromText, toText) {
                  final minPrice = fromText.length == 0
                      ? -1.0
                      : double.tryParse(fromText.replaceAll('.', ''));
                  final maxPrice = toText.length == 0
                      ? -1.0
                      : double.tryParse(toText.replaceAll('.', ''));
                  parentBloc.search(minPrice: minPrice, maxPrice: maxPrice);
                },
              ),
              SizedBox(
                height: 16,
              ),
              LabelText(
                label: 'Diện tích',
              ),
              SizedBox(
                height: 8,
              ),
              FilterProjectInputView(
                key: _filterSizeInput,
                fromText: parentBloc.categorySearchRequest.minSize,
                toText: parentBloc.categorySearchRequest.maxSize,
                fromPlaceHolder: 'Từ',
                toPlaceHolder: 'Đến',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLength: 6,
                isDisplayUnit: true,
                onEndEditing: (fromText, toText) {
                  final minSize = fromText.length == 0
                      ? -1.0
                      : double.tryParse(fromText.replaceAll(',', '.'));
                  final maxSize = toText.length == 0
                      ? -1.0
                      : double.tryParse(toText.replaceAll(',', '.'));
                  parentBloc.search(minSize: minSize, maxSize: maxSize);
                },
              ),
              SizedBox(
                height: 16,
              ),
              LabelText(
                label: 'Số phòng ngủ',
              ),
              BedroomPage(),
              SizedBox(
                height: 16,
              ),
              LabelText(
                label: 'Số phòng tắm',
              ),
              BathroomPage(),
              SizedBox(
                height: 16,
              ),
              LabelText(
                label: 'Vị trí',
              ),
              PositionPage(),
              SizedBox(
                height: 16,
              ),
              LabelText(
                label: 'Hướng',
              ),
              DirectionPage(),
              SizedBox(
                height: 16,
              ),
              LabelText(
                label: 'Năm xây dựng',
              ),
              SizedBox(
                height: 8,
              ),
              FilterProjectInputView(
                key: _filterYearInput,
                fromPlaceHolder: 'Từ năm',
                toPlaceHolder: 'Đến năm',
                fromText: parentBloc.categorySearchRequest.minYear?.toDouble(),
                toText: parentBloc.categorySearchRequest.maxYear?.toDouble(),
                keyboardType: TextInputType.number,
                maxLength: 4,
                onEndEditing: (fromText, toText) {
                  final minYear =
                      fromText.length == 0 ? -1 : int.tryParse(fromText);
                  final maxYear =
                      toText.length == 0 ? -1 : int.tryParse(toText);
                  parentBloc.search(minYear: minYear, maxYear: maxYear);
                },
              ),
              SizedBox(
                height: 16,
              ),
              LabelText(
                label: 'Tiện ích',
              ),
              AdvantagePage(),
              SizedBox(
                height: 16,
              ),
              LabelText(
                label: 'Nội dung',
              ),
              SizedBox(
                height: 8,
              ),
              ContentPage(),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 25,
                    child: Switch(
                      value: _switchChecked,
                      onChanged: (value) {
                        setState(() {
                          _switchChecked = value;
                        });

                        List<int> statusIds = [];
                        if (value) {
                          statusIds.add(
                              Constants.CATEGORY_FILTER_STATUS_SOLD_OR_RENT);
                        } else {
                          statusIds.add(Constants.CATEGORY_FILTER_STATUS_LIVE);
                        }
                        parentBloc.search(statusIds: statusIds);
                      },
                      activeTrackColor: HexColor('0072EF'),
                      activeColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Đã bán',
                  ),
                ],
              ),
              Container(
                height: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
