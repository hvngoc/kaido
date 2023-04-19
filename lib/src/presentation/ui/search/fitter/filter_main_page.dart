import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';
import 'package:propzy_home/src/presentation/ui/search/filter_project/filter_project_view.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/tab_buy_filter_page.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/tab_rent_filter_page.dart';
import 'package:propzy_home/src/presentation/ui/search/search/search.dart';
import 'package:propzy_home/src/util/app_colors.dart';

import '../../../../data/model/search_model.dart';
import '../../../view/tab_bar_segment_view.dart';
import '../../../view/top_search_bar_view.dart';
import '../filter_project/filter_project_select_view.dart';
import 'bloc/search_filter_bloc.dart';
import 'bloc/search_filter_state.dart';

class FilterMainPage extends StatefulWidget {
  FilterMainPage({
    Key? key,
    required this.searchRequest,
    required this.listSearchSelected,
    required this.initTotalElement,
  }) : super(key: key);

  final CategorySearchRequest searchRequest;
  final List<SearchHistory> listSearchSelected;
  final int initTotalElement;

  @override
  State<FilterMainPage> createState() => _FilterMainState(listSearchSelected);
}

class _FilterMainState extends State<FilterMainPage>
    with TickerProviderStateMixin {
  _FilterMainState(this.listSearchSelected);

  List<SearchHistory> listSearchSelected = [];

  static final _tabBuyFilter = new GlobalKey<TabBuyFilterPageState>();
  static final _tabRentFilter = new GlobalKey<TabRentFilterPageState>();
  static final _tabProjectFilter = new GlobalKey<FilterProjectViewState>();

  late final TabController tabController;
  late final SearchFilterBloc parentBloc;
  int startOffset = 0;

  @override
  void initState() {
    if (widget.searchRequest.categoryType.type == CategoryType.RENT.type) {
      startOffset = 1;
    } else if (widget.searchRequest.categoryType.type ==
        CategoryType.PROJECT.type) {
      startOffset = 2;
    }
    tabController =
        TabController(initialIndex: startOffset, length: 3, vsync: this);

    parentBloc = context.read<SearchFilterBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
    KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<SearchFilterBloc, SearchFilterState>(
              builder: (BuildContext context, state) {
                return TopSearchBarView(
                  listSearchSelected: listSearchSelected,
                  onClickAddMoreSearch: () {
                    _goToSearchView();
                  },
                  onClickFilterSearch: () {
                    Navigator.pop(context, {
                      "listSearchSelected": listSearchSelected,
                      "categorySearchRequest": parentBloc.categorySearchRequest,
                    });
                  },
                  onDeleteItemSearch: (bool isGroupItem, int position) {
                    if (isGroupItem) {
                      SearchHistory lastItem = listSearchSelected.last;
                      listSearchSelected.removeRange(
                          0, listSearchSelected.length);
                      listSearchSelected.add(lastItem);
                    } else {
                      listSearchSelected.removeAt(position);
                    }
                    _onLocationTagChange(listSearchSelected);
                  },
                  isSelected: parentBloc.categorySearchRequest.isFiltering(),
                );
              },
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: AbsorbPointer(
                        absorbing: isKeyboardVisible,
                        child: TabBarSegmentView(
                          onTabChange: (value) {
                            tabController.index = value;
                            final newType = CategoryType.fromValue(value! + 1);
                            int listingTypeId = newType.type;
                            if (listingTypeId == CategoryType.PROJECT.type) {
                              listingTypeId = CategoryType.BUY.type;
                            }
                            parentBloc.categorySearchRequest =
                                parentBloc.categorySearchRequest.resetFilter(
                                  listingTypeId: listingTypeId,
                                  categoryType: newType,
                                );

                            parentBloc.saveCategoryType(newType);

                            if (CategoryType.PROJECT.type == newType.type) {
                              parentBloc.search(
                                  isSearchProject: true,
                                  listingTypeId: listingTypeId);
                            } else {
                              parentBloc.search(listingTypeId: listingTypeId);
                            }
                          },
                          startOffset: tabController.index,
                        ),
                      ),
                    )
                  ];
                },
                body: AbsorbPointer(
                  absorbing: isKeyboardVisible,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      TabBuyFilterPage(
                        key: _tabBuyFilter,
                      ),
                      TabRentFilterPage(
                        key: _tabRentFilter,
                      ),
                      FilterProjectView(
                        key: _tabProjectFilter,
                        defaultStatusIds: parentBloc.categorySearchRequest.statusIds),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .padding
                    .bottom,
              ),
              child: BlocBuilder<SearchFilterBloc, SearchFilterState>(
                builder: (BuildContext context, state) {
                  if (state is InitDataState) {
                    return Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                height: 40,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppColor.grayD5,
                                  shadowColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  showAlertDialog(context);
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      child: SvgPicture.asset(
                                        'assets/images/filter_black_refresh.svg',
                                      ),
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "Chọn lại",
                                      style: TextStyle(
                                        color: AppColor.blackDefault,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                height: 40,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppColor.propzyOrange,
                                  shadowColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  Navigator.pop(context, {
                                    "listSearchSelected": listSearchSelected,
                                    "categorySearchRequest":
                                    parentBloc.categorySearchRequest,
                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      child: SvgPicture.asset(
                                        'assets/images/ic_white_search.svg',
                                      ),
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "Xem ${state.data?.totalElements ??
                                          widget.initTotalElement} ${parentBloc
                                          .categorySearchRequest.categoryType
                                          .type == CategoryType.PROJECT.type
                                          ? 'dự án'
                                          : 'BĐS'}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  void _goToSearchView() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SearchPage(
                    listSearchSelected: listSearchSelected,
                    categoryType: parentBloc.categorySearchRequest
                        .categoryType)));

    List<SearchHistory> list =
    result["listSearchSelected"] as List<SearchHistory>;
    _onLocationTagChange(list);
  }

  void _onLocationTagChange(List<SearchHistory> list) {
    setState(() {
      listSearchSelected = list;
    });

    if (CategoryType.PROJECT.type ==
        parentBloc.categorySearchRequest.categoryType.type) {
      parentBloc.searchAddressProject(listSearchSelected: listSearchSelected);
    } else {
      parentBloc.searchAddress(listSearchSelected: listSearchSelected);
    }
  }

  void showAlertDialog(BuildContext context) {
    {
      Dialog dialog = Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)), //this right here
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(onTap: () {
                    Navigator.pop(context);
                  },
                      child: SvgPicture.asset(
                          'assets/images/ic_close.svg')),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                      child: Text(
                        "Bạn muốn xóa tất cả bộ lọc ?",
                        style: TextStyle(
                          color: AppColor.blackDefault,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ))
                ],
              ),

              SizedBox(height: 48),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: 40,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.grayD5,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              "Không, Cảm ơn",
                              style: TextStyle(
                                color: AppColor.blackDefault,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: 40,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.propzyOrange,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          parentBloc.resetFilterSearch();

                          if (parentBloc.categorySearchRequest.categoryType == CategoryType.BUY) {
                            _tabBuyFilter.currentState?.resetInputFilter();
                            parentBloc.categorySearchRequest = parentBloc.categorySearchRequest.resetFilter(categoryType: CategoryType.BUY);

                          } else if (parentBloc.categorySearchRequest.categoryType == CategoryType.RENT) {
                            parentBloc.categorySearchRequest = parentBloc.categorySearchRequest.resetFilter(categoryType: CategoryType.RENT);
                            _tabRentFilter.currentState?.resetInputFilter();
                          }
                          else {
                            parentBloc.categorySearchRequest = parentBloc.categorySearchRequest.resetFilter(categoryType: CategoryType.PROJECT);
                            _tabProjectFilter.currentState?.resetTextField();
                          }
                          parentBloc.search();
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              "Có",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    }
  }
}
