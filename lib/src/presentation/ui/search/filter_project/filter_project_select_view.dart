import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/ui/search/filter_project/filter_project_model.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class FilterSelectionStatusView extends StatelessWidget {
  const FilterSelectionStatusView({
    Key? key,
    required this.listItems,
    required this.onClickHandler,
  }) : super(key: key);

  final List<FilterSelectionType> listItems;
  final void Function(int) onClickHandler;

  void handleOnClick(FilterSelectionType item) {
    onClickHandler(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: listItems
          .map((item) => FilterSelectionItemView(
                item: item,
                onClick: () {
                  handleOnClick(item);
                },
              ))
          .toList(),
    );
  }
}

class FilterSelectionView extends StatefulWidget {
  final List<FilterSelectionType> listItems;
  final int currentSelected;
  final void Function(int) onClickHandler;

  const FilterSelectionView({
    Key? key,
    required this.listItems,
    required this.currentSelected,
    required this.onClickHandler,
  }) : super(key: key);

  @override
  State<FilterSelectionView> createState() => _FilterSelectionViewState();
}

class _FilterSelectionViewState extends State<FilterSelectionView> {
  late List<FilterSelectionType> _listData;

  @override
  void initState() {
    _listData = widget.listItems;
    for (var i = 0; i < _listData.length; i++) {
      if (_listData[i].id == widget.currentSelected) {
        _listData[i].isSelected = true;
      } else {
        _listData[i].isSelected = false;
      }
    }

    super.initState();
  }

  void handleOnClick(FilterSelectionType item) {
    final index = _listData.indexOf(item);
    if(item.isSelected){
      return;
    }
    setState(() {
      for (var i = 0; i < _listData.length; i++) {
        _listData[i].isSelected = false;
      }
      _listData[index].isSelected = true;
    });
    widget.onClickHandler(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _listData
          .map((item) => FilterSelectionItemView(
                item: item,
                onClick: () {
                  handleOnClick(item);
                },
              ))
          .toList(),
    );
  }
}

class FilterSelectionItemView extends StatelessWidget {
  final FilterSelectionType item;
  final GestureTapCallback onClick;

  const FilterSelectionItemView({
    Key? key,
    required this.item,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      height: 42,
      child: OutlinedButton(
        onPressed: onClick,
        child: Text(
          item.name,
          style: TextStyle(
            color:
                item.isSelected ? AppColor.propzyBlue : AppColor.blackDefault,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              item.isSelected ? Colors.transparent : AppColor.grayF4,
          side: BorderSide(
            width: 1.0,
            color: item.isSelected ? AppColor.propzyBlue : AppColor.grayF4,
          ),
        ),
      ),
    );
  }
}
