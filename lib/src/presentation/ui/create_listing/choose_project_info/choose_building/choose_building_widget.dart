import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/domain/model/listing_building.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_project_info/choose_building/bloc/choose_building_bloc.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/debounce_timer.dart';

class ChooseBuildingWidget extends StatefulWidget {
  static final String PARAM = "ChooserData";

  const ChooseBuildingWidget({
    Key? key,
    required this.districtId,
    this.lastChooser,
    this.listChooser,
  }) : super(key: key);

  final int districtId;
  final ListingBuilding? lastChooser;
  final List<ListingBuilding>? listChooser;

  @override
  State<ChooseBuildingWidget> createState() => _ChooseBuildingWidgetState();
}

class _ChooseBuildingWidgetState extends State<ChooseBuildingWidget> {
  final TimerDebounce _timerDebounce = TimerDebounce(milliseconds: 600);
  final ChooseBuildingBloc _bloc = ChooseBuildingBloc();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadDataEvent(widget.districtId));
  }

  @override
  void dispose() {
    _timerDebounce.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none),
    );
    return BlocProvider(
      create: (_) => _bloc,
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
                        'Chọn chung cư/dự án',
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
                  controller: _controller,
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
                    hintText: 'Nhập tên chung cư/dự án',
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
                    _timerDebounce.run(() => _bloc.add(SearchNameEvent(text)));
                  },
                ),
              ),
              BlocBuilder<ChooseBuildingBloc, ChooseBuildingState>(builder: (context, state) {
                if (state is ChooseBuildingLoading) {
                  return Center(
                    child: LoadingView(width: 100, height: 100),
                  );
                } else if (state is ChooseBuildingEmpty) {
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(bottom: 20),
                      shrinkWrap: true,
                      children: _buildListItem([]),
                    ),
                  );
                } else if (state is ChooseBuildingSuccess) {
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

  List<Widget> _buildListItem(List<ListingBuilding> data) {
    List<Widget> result = [];
    for (var i = 0; i < data.length; ++i) {
      result.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: SortItemChildView(
            text: data[i].name ?? '',
            isChecked: _isSelected(data[i]),
            onClick: () {
              Navigator.pop(
                context,
                {
                  ChooseBuildingWidget.PARAM: data[i],
                },
              );
            },
          ),
        ),
      );
      result.add(Divider(height: 1, color: AppColor.dividerGray));
    }
    if (_controller.text.isNotEmpty) {
      result.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: InkWell(
            onTap: () {
              Navigator.pop(
                context,
                {
                  ChooseBuildingWidget.PARAM: ListingBuilding(name: _controller.text),
                },
              );
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _controller.text,
                      style: TextStyle(
                        color: AppColor.black_80p,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Thêm mới',
                    style: TextStyle(
                      color: HexColor("0072EF"),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return result;
  }

  bool _isSelected(ListingBuilding item) {
    return item.id == widget.lastChooser?.id ||
        widget.listChooser?.any((element) => element.id == item.id) == true;
  }
}
