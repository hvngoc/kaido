import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class TopSearchBarView extends StatelessWidget {
  const TopSearchBarView({
    Key? key,
    required this.isSelected,
    required this.listSearchSelected,
    required this.onDeleteItemSearch,
    required this.onClickAddMoreSearch,
    required this.onClickFilterSearch,
  }) : super(key: key);

  final bool isSelected;
  final List<SearchHistory> listSearchSelected;
  final Function onClickAddMoreSearch;
  final Function onClickFilterSearch;
  final Function(bool isGroupItem, int position) onDeleteItemSearch;


  @override
  Widget build(BuildContext context) {
    bool emptyAddress = listSearchSelected.isEmpty;

    return Material(
      elevation: 4,
      color: Colors.white,
      shadowColor: AppColor.dividerGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: emptyAddress
                ? _renderEmptySearchSelectedView(context)
                : _renderListSearchSelectedView(context),
          ),
          InkResponse(
            onTap: () {
              onClickFilterSearch();
            },
            child: Container(
              width: 44,
              height: 50,
              child: Transform.rotate(
                angle: -math.pi / 2,
                child: Icon(
                  Icons.tune,
                  color: isSelected ? AppColor.orangeDark : AppColor.blackDefault,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderEmptySearchSelectedView(BuildContext context) {
    return Container(
      width: double.infinity,
      child: InkWellWithoutRipple(
        onTap: () {
          onClickAddMoreSearch();
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Nhập khu vực bạn muốn tìm kiếm...',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.black_40p,
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderListSearchSelectedView(BuildContext context) {
    bool emptyAddress = listSearchSelected.isEmpty;
    List<Widget> listSearchWidget = <Widget>[];
    if (!emptyAddress) {
      if (listSearchSelected.length > 2) {
        listSearchWidget.add(_renderItemSearchSelectedView(
            true, 0, (isGroupItem, position) => onDeleteItemSearch(true, 0)));
        listSearchWidget.add(_renderItemSearchSelectedView(false, listSearchSelected.length - 1,
            (isGroupItem, position) => onDeleteItemSearch(false, listSearchSelected.length - 1)));
      } else {
        for (int i = 0; i < listSearchSelected.length; i++) {
          listSearchWidget.add(_renderItemSearchSelectedView(
              false, i, (isGroupItem, position) => onDeleteItemSearch(false, i)));
        }
      }
    }

    if (listSearchSelected.length < 5) {
      listSearchWidget.add(
        Container(
          margin: EdgeInsets.only(left: 5),
          child: InkResponse(
            onTap: () {
              onClickAddMoreSearch();
            },
            radius: 20,
            child: SvgPicture.asset("assets/images/vector_ic_search_add_more.svg"),
          ),
        ),
      );
    }

    if (listSearchSelected.isNotEmpty) {
      return Container(
        height: 50,
        padding: EdgeInsets.only(left: 10),
        child: GestureDetector(
          onTap: () {
            onClickAddMoreSearch();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 11),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: listSearchWidget,
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 28,
        padding: EdgeInsets.only(left: 10),
      );
    }
  }

  Widget _renderItemSearchSelectedView(
      bool isGroupItem, int position, Function(bool isGroupItem, int position) onDelete) {
    SearchHistory searchItemView = listSearchSelected[position];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: HexColor("#D8D8DC"),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.only(
        right: 5,
      ),
      child: InkWellWithoutRipple(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isGroupItem
                  ? "Đã chọn +${listSearchSelected.length - 1}"
                  : searchItemView.searchString.toString(),
            ),
            InkResponse(
              radius: 20,
              child: SvgPicture.asset("assets/images/ic_remove_item_search.svg"),
              onTap: () {
                onDelete(isGroupItem, position);
              },
            ),
          ],
        ),
        onTap: () {
          if (isGroupItem) {
            onClickAddMoreSearch();
          }
        },
      ),
    );
  }
}
