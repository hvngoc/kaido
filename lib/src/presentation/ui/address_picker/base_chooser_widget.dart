import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_event.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_state.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/debounce_timer.dart';

abstract class BaseChooserScreen extends StatefulWidget {
  static final String PARAM = "ChooserData";

  final ChooserData? lastChooser;
  final List<ChooserData>? listChooser;
  final dynamic value;
  bool canAddMoreData;
  String textAddMore;

  BaseChooserScreen({
    Key? key,
    this.lastChooser,
    this.value,
    this.listChooser,
    this.canAddMoreData = false,
    this.textAddMore = "",
  }) : super(key: key);
}

abstract class BaseChooserState extends State<BaseChooserScreen> {
  abstract ChooserBloc chooserBloc;
  abstract String title;
  abstract String hintSearch;

  final TimerDebounce _timerDebounce = TimerDebounce(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    chooserBloc.canAddMoreData = widget.canAddMoreData;
    chooserBloc.add(LoadDataEvent(widget.value));
  }

  @override
  void dispose() {
    _timerDebounce.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none),
    );

    return BlocProvider(
      create: (_) => chooserBloc,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 6),
                      BackButton(
                        color: AppColor.blackDefault,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: AppColor.blackDefault,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  cursorColor: AppColor.orangeDark,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black38),
                    border: border,
                    focusedBorder: border,
                    enabledBorder: border,
                    filled: true,
                    fillColor: AppColor.grayF4,
                    focusColor: AppColor.grayF4,
                    contentPadding: EdgeInsets.all(8),
                    hintText: hintSearch,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.gray89,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.blackDefault,
                  ),
                  onChanged: (text) {
                    _timerDebounce.run(() => chooserBloc.add(SearchNameEvent(text)));
                  },
                ),
              ),
              BlocBuilder<ChooserBloc, ChooserState>(builder: (context, state) {
                if (state is ChooserLoading) {
                  return Center(
                    child: LoadingView(width: 100, height: 100),
                  );
                } else if (state is ChooserEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(30),
                    child: Text('Không có kết quả'),
                  );
                } else if (state is ChooserSuccess) {
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(bottom: 20),
                      shrinkWrap: true,
                      children: _buildListItem(state.listData),
                    ),
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListItem(List<ChooserData> data) {
    List<Widget> result = [];
    for (var i = 0; i < data.length; ++i) {
      bool isisAddMore = data[i].isAddMore ?? false;
      result.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: SortItemChildView(
            text: data[i].name ?? '',
            isChecked: isisAddMore ? false : _isSelected(data[i]),
            isAddMore: isisAddMore,
            textAddMore: widget.textAddMore,
            onClick: () {
              Navigator.pop(context, {BaseChooserScreen.PARAM: data[i]});
            },
          ),
        ),
      );
      if (i != data.length - 1) {
        result.add(Divider(height: 1, color: AppColor.dividerGray));
      }
    }
    return result;
  }

  bool _isSelected(ChooserData item) {
    return item.id == widget.lastChooser?.id ||
        widget.listChooser?.any((element) => element.id == item.id) == true;
  }
}
