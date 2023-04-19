import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ItemSync {
  final String? text;
  final Widget body;

  ItemSync(this.text, this.body);
}

class ScrollableTabSync extends StatefulWidget {
  const ScrollableTabSync({
    Key? key,
    required this.tabs,
    required this.showHideAppBar,
  }) : super(key: key);

  final List<ItemSync> tabs;
  final Function(bool isShow) showHideAppBar;

  @override
  _ScrollableTabSyncState createState() => _ScrollableTabSyncState();
}

class _ScrollableTabSyncState extends State<ScrollableTabSync> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);

  final ItemScrollController _bodyScrollController = ItemScrollController();
  final ItemPositionsListener _bodyPositionsListener = ItemPositionsListener.create();
  final ItemScrollController _tabScrollController = ItemScrollController();
  bool _isShowAppBar = false;

  @override
  void initState() {
    super.initState();
    _bodyPositionsListener.itemPositions.addListener(_onInnerViewScrolled);
  }

  @override
  void dispose() {
    _bodyPositionsListener.itemPositions.removeListener(_onInnerViewScrolled);
    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: _isShowAppBar,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: AppColor.dividerGray,
                ),
              ),
            ),
            child: ScrollablePositionedList.builder(
              physics: ClampingScrollPhysics(),
              itemCount: widget.tabs.length,
              scrollDirection: Axis.horizontal,
              itemScrollController: _tabScrollController,
              itemBuilder: (context, index) {
                var tab = widget.tabs[index].text;
                return ValueListenableBuilder<int>(
                  valueListenable: _index,
                  builder: (_, i, __) {
                    var selected = index == i;
                    return Visibility(
                      visible: tab != null,
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2,
                              color: selected ? AppColor.orangeDark : Colors.white,
                            ),
                          ),
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            overlayColor:
                                MaterialStateColor.resolveWith((states) => AppColor.rippleDark),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            tab ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selected ? AppColor.orangeDark : AppColor.gray44,
                            ),
                          ),
                          onPressed: () => _onTabPressed(index),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        Expanded(
          child: ScrollablePositionedList.builder(
            physics: ClampingScrollPhysics(),
            itemScrollController: _bodyScrollController,
            itemPositionsListener: _bodyPositionsListener,
            itemCount: widget.tabs.length,
            itemBuilder: (_, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: widget.tabs[index].body,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onInnerViewScrolled() async {
    var positions = _bodyPositionsListener.itemPositions.value;
    if (positions.isEmpty) {
      return;
    }
    var firstIndex = _bodyPositionsListener.itemPositions.value.elementAt(0).index;
    if (_index.value == firstIndex) {
      return;
    }
    await _handleTabScroll(firstIndex);
  }

  Future<void> _handleTabScroll(int index) async {
    _index.value = index;
    widget.showHideAppBar(index >= 2);
    setState(() {
      _isShowAppBar = index >= 2;
    });
    // _tabScrollController.jumpTo(index: index);
    await _tabScrollController.scrollTo(
      index: _index.value,
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }

  void _onTabPressed(int index) async {
    // _tabScrollController.jumpTo(index: index);
    // _bodyScrollController.jumpTo(index: index);
    // widget.showHideAppBar(index >= 2);
    await _tabScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
    );
    await _bodyScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
    );
    await Future.delayed(Duration(milliseconds: 200), () {
      _index.value = index;
    });
  }
}
