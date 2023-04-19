import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_ward/choose_ward_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class ChooseWardScreen extends BaseChooserScreen {
  ChooseWardScreen({
    Key? key,
    ChooserData? lastChooser,
    List<ChooserData>? listChooser,
    required int districtId,
  }) : super(key: key, lastChooser: lastChooser, value: districtId, listChooser: listChooser);

  @override
  State<StatefulWidget> createState() => _ChooseWardState();
}

class _ChooseWardState extends BaseChooserState {
  @override
  ChooserBloc chooserBloc = ChooserWardBloc();

  @override
  String hintSearch = 'Nhập Phường/Xã để tìm kiếm';

  @override
  String title = 'Chọn Phường/Xã';
}
