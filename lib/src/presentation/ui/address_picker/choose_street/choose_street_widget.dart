import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/choose_street/choose_street_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class ChooseStreetScreen extends BaseChooserScreen {
  ChooseStreetScreen({
    Key? key,
    ChooserData? lastChooser,
    List<ChooserData>? listChooser,
    required int wardId,
    bool canAddMoreData = false,
    String textAddMore = "",
  }) : super(
          key: key,
          lastChooser: lastChooser,
          listChooser: listChooser,
          value: wardId,
          canAddMoreData: canAddMoreData,
          textAddMore: textAddMore,
        );

  @override
  State<StatefulWidget> createState() => _ChooseStreetState();
}

class _ChooseStreetState extends BaseChooserState {
  @override
  ChooserBloc chooserBloc = ChooserStreetBloc();

  @override
  String hintSearch = 'Nhập tên đường để tìm kiếm';

  @override
  String title = 'Chọn đường';
}
