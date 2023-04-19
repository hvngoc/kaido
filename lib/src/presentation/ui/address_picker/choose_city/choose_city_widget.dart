import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_city/choose_city_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class ChooseCityScreen extends BaseChooserScreen {
  ChooseCityScreen({Key? key, ChooserData? lastChooser})
      : super(key: key, lastChooser: lastChooser);

  @override
  State<StatefulWidget> createState() => _ChooseCityState();
}

class _ChooseCityState extends BaseChooserState {
  @override
  ChooserBloc chooserBloc = ChooserCityBloc();

  @override
  String hintSearch = 'Nhập Tỉnh/Thành để tìm kiếm';

  @override
  String title = 'Chọn Tỉnh/Thành';
}
