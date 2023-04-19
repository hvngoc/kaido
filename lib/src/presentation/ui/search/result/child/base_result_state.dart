import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/search_filter_view.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_event.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_state.dart';
import 'package:propzy_home/src/presentation/ui/search/result/child/base_result_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/result/sort_by_home.dart';
import 'package:propzy_home/src/presentation/ui/search/search/search.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/presentation/view/sort_header_view.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/presentation/view/top_search_bar_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/log.dart';

abstract class BaseSearchResultState<T> extends State<BaseResultWidget> {
  abstract BaseResultBloc<T> homeResultBloc;

  late ScrollController controller;

  bool isLoadingMore = false;
  List<SearchHistory> listSearchSelected = [];

  @override
  void initState() {
    super.initState();
    listSearchSelected = widget.listSearchSelected;
    homeResultBloc.categoryRequest = widget.request;

    controller = ScrollController()..addListener(_scrollListener);
    if (widget.isFirstRunTime) {
      homeResultBloc.add(GetLastSearchEvent());
    } else {
      homeResultBloc.add(UpdateLocationTag(listSearchSelected));
    }
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 50 && !isLoadingMore && !homeResultBloc.isLastPage) {
      isLoadingMore = true;
      Log.d("trigger loading more");
      homeResultBloc.add(GetListHomeLoadMoreEvent());
    }
  }

  String getSortTile(int? totalItem);

  @override
  Widget build(BuildContext context) {
    BlocProvider(create: (BuildContext context) => homeResultBloc);
    return BlocConsumer<BaseResultBloc, CategoryResultState>(
        bloc: homeResultBloc,
        builder: (context, state) {
          Log.i('build search page = ${homeResultBloc.page} isLoadingMore = $isLoadingMore');
          isLoadingMore = false;
          if (state is SuccessState) {
            int _size = (state.data?.content?.length ?? 0);
            _size = _size + (homeResultBloc.isLastPage ? 0 : 1);
            Log.w('size $_size');

            if (controller.hasClients && homeResultBloc.page == 0) {
              controller.jumpTo(0);
            }
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    _buildTopSearchBar(),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 4, top: 4),
                      child: SortHeaderView(
                        title: getSortTile(state.data?.totalElements),
                        sortByTitle: homeResultBloc.sortBy.name,
                        onClick: () {
                          showModalBottomSheet(context: context, builder: buildSortByView);
                        },
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          homeResultBloc.add(GetListHomeEvent());

                          ///TODO fixme
                          await Future.delayed(Duration(milliseconds: 1000));
                        },
                        color: AppColor.orangeDark,
                        displacement: 20,
                        child: ListView.builder(
                          controller: controller,
                          // physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, position) {
                            bool showMore = position == _size - 1 && !homeResultBloc.isLastPage;
                            Log.w('showMore $showMore position = $position');
                            return buildCardItemSearch(
                                showMore ? null : state.data?.content?[position]);
                          },
                          itemCount: _size,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (state is EmptyState) {
            return Scaffold(
              backgroundColor: AppColor.white,
              body: SafeArea(
                child: Column(
                  children: [
                    _buildTopSearchBar(),
                    Expanded(
                      child: buildEmptyView(),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
                backgroundColor: AppColor.white,
                body: Center(
                  child: LoadingView(
                    width: 160,
                    height: 160,
                  ),
                ));
          }
        },
        listener: (context, state) {
          if (state is GetLastSearchSuccess) {
            _addItemSearch(state.searchItemView);
          }
        });
  }

  void _addItemSearch(SearchHistory searchItemView) {
    bool isAddToList = false;
    if (listSearchSelected.isEmpty) {
      isAddToList = true;
    } else {
      if (listSearchSelected.length < 5) {
        for (int i = 0; i < listSearchSelected.length; i++) {
          SearchHistory item = listSearchSelected[i];
          if (searchItemView.isUseMyLocation == true) {
            if (item.isUseMyLocation == true) {
              break;
            } else {
              if (i == listSearchSelected.length - 1) {
                isAddToList = true;
                break;
              }
            }
          } else {
            if (searchItemView.searchId == item.searchId) {
              break;
            } else {
              if (i == listSearchSelected.length - 1) {
                isAddToList = true;
                break;
              }
            }
          }
        }
      }
    }

    if (isAddToList == true) {
      listSearchSelected.add(searchItemView);
      _onLocationTagChange(listSearchSelected);
    }
  }

  Widget _buildTopSearchBar() {
    return TopSearchBarView(
      listSearchSelected: listSearchSelected,
      onClickAddMoreSearch: () {
        goToSearchView();
      },
      onClickFilterSearch: () {
        _goToFilterSearchView();
      },
      onDeleteItemSearch: (bool isGroupItem, int position) {
        if (isGroupItem) {
          SearchHistory lastItem = listSearchSelected.last;
          listSearchSelected.removeRange(0, listSearchSelected.length);
          listSearchSelected.add(lastItem);
        } else {
          listSearchSelected.removeAt(position);
        }
        _onLocationTagChange(listSearchSelected);
      },
      isSelected: homeResultBloc.categoryRequest.isFiltering(),
    );
  }

  Widget buildEmptyView();

  Widget buildCardItemSearch(T? home);

  Widget buildSortByView(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                'Sắp xếp dữ liệu',
                style: TextStyle(
                  color: AppColor.blackDefault,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            SortItemChildView(
                text: SortBy.DEFAULT.name,
                isChecked: homeResultBloc.sortBy.key == SortBy.DEFAULT.key,
                onClick: () {
                  homeResultBloc.add(ChangeSortByEvent(SortBy.DEFAULT));
                  Navigator.pop(context);
                }),
            Divider(height: 1, color: AppColor.dividerGray),
            SortItemChildView(
                text: SortBy.NEWEST.name,
                isChecked: homeResultBloc.sortBy.key == SortBy.NEWEST.key,
                onClick: () {
                  homeResultBloc.add(ChangeSortByEvent(SortBy.NEWEST));
                  Navigator.pop(context);
                }),
            Divider(height: 1, color: AppColor.dividerGray),
            SortItemChildView(
                text: SortBy.PRICE_UP.name,
                isChecked: homeResultBloc.sortBy.key == SortBy.PRICE_UP.key,
                onClick: () {
                  homeResultBloc.add(ChangeSortByEvent(SortBy.PRICE_UP));
                  Navigator.pop(context);
                }),
            Divider(height: 1, color: AppColor.dividerGray),
            SortItemChildView(
                text: SortBy.PRICE_DOWN.name,
                isChecked: homeResultBloc.sortBy.key == SortBy.PRICE_DOWN.key,
                onClick: () {
                  homeResultBloc.add(ChangeSortByEvent(SortBy.PRICE_DOWN));
                  Navigator.pop(context);
                }),
            Divider(height: 1, color: AppColor.dividerGray),
            SortItemChildView(
                text: SortBy.SIZE_UP.name,
                isChecked: homeResultBloc.sortBy.key == SortBy.SIZE_UP.key,
                onClick: () {
                  homeResultBloc.add(ChangeSortByEvent(SortBy.SIZE_UP));
                  Navigator.pop(context);
                }),
            Divider(height: 1, color: AppColor.dividerGray),
            SortItemChildView(
                text: SortBy.SIZE_DOWN.name,
                isChecked: homeResultBloc.sortBy.key == SortBy.SIZE_DOWN.key,
                onClick: () {
                  homeResultBloc.add(ChangeSortByEvent(SortBy.SIZE_DOWN));
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  void goToSearchView() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchPage(
                listSearchSelected: listSearchSelected,
                categoryType: homeResultBloc.categoryRequest.categoryType)));

    List<SearchHistory> list = result["listSearchSelected"] as List<SearchHistory>;
    _onLocationTagChange(list);
  }

  void _goToFilterSearchView() async {
    int total = 0;
    if (homeResultBloc.state is SuccessState) {
      total = (homeResultBloc.state as SuccessState).data?.totalElements ?? 0;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchFilterView(
          searchRequest: homeResultBloc.categoryRequest.clone(),
          listSearchSelected: listSearchSelected,
          initTotalElement: total,
        ),
      ),
    );

    final listAddress = result["listSearchSelected"] as List<SearchHistory>;
    final filterRequest = result["categorySearchRequest"] as CategorySearchRequest;

    CategoryType filterType = filterRequest.categoryType;
    if (filterType.type == homeResultBloc.categoryRequest.categoryType.type) {
      setState(() {
        listSearchSelected = listAddress;
      });
      homeResultBloc.add(UpdateFilter(listSearchSelected, filterRequest));
    } else {
      widget.onTypeChange(filterRequest, listAddress);
    }
  }

  void _onLocationTagChange(List<SearchHistory> list) {
    setState(() {
      listSearchSelected = list;
    });
    homeResultBloc.add(UpdateLocationTag(listSearchSelected));
  }
}
