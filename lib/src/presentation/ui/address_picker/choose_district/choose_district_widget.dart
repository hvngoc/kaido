import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_bloc.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_district/choose_district_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class ChooseDistrictScreen extends BaseChooserScreen {
  ChooseDistrictScreen({Key? key, ChooserData? lastChooser, List<ChooserData>? listChooser})
      : super(key: key, lastChooser: lastChooser, listChooser: listChooser);

  @override
  State<StatefulWidget> createState() => _ChooseDistrictState();
}

class _ChooseDistrictState extends BaseChooserState {
  @override
  ChooserBloc chooserBloc = ChooserDistrictBloc();

  @override
  String hintSearch = 'Nhập Quận/Huyện để tìm kiếm';

  @override
  String title = 'Chọn Quận/Huyện';
}
