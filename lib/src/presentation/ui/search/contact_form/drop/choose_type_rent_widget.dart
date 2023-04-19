import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/choose_type_rent_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class ChoosePropertiesRentScreen extends BaseChooserScreen {
  ChoosePropertiesRentScreen({Key? key, required ChooserData? lastChooser})
      : super(key: key, lastChooser: lastChooser);

  @override
  State<StatefulWidget> createState() => _ChoosePropertiesState();
}

class _ChoosePropertiesState extends BaseChooserState {
  @override
  ChooserBloc chooserBloc = ChooserPropertiesRentBloc();

  @override
  String title = 'Chọn loại BĐS';

  @override
  String hintSearch = 'Nhập loại BĐS để tìm kiếm';
}
