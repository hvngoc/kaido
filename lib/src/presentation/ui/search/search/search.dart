import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/search/search/search_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/search/search_event.dart';
import 'package:propzy_home/src/presentation/ui/search/search/search_state.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/location_util.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:rxdart/rxdart.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    required this.listSearchSelected,
    required this.categoryType,
  }) : super(key: key);
  final List<SearchHistory> listSearchSelected;
  final CategoryType categoryType;

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchBloc _searchBloc = GetIt.instance.get<SearchBloc>();

  List<SearchHistory> listSearchHistoryRecently = <SearchHistory>[];
  List<SearchGroupSuggestion> listSearchSuggestion = <SearchGroupSuggestion>[];
  String textSearch = "";
  late List<SearchHistory> listSearchSelected;

  Subject streamTextSearchChangeController = PublishSubject();

  @override
  void dispose() {
    streamTextSearchChangeController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    listSearchSelected = widget.listSearchSelected;
    streamTextSearchChangeController.stream
        .debounceTime(Duration(milliseconds: 500))
        .listen((event) {
      setState(() {
        textSearch = event;
      });
      if (event.length > 1) {
        _searchBloc.add(GetLocationAutoCompleteEvent(event, widget.categoryType.slug));
      }
    });

    _searchBloc.add(GetSearchHistoryEvent());
  }

  void onSearchTextChanged(newText) {
    streamTextSearchChangeController.add(newText);
  }

  Future<void> onClickUseMyLocation() async {
    if (await Permission.location.isGranted) {
      getCurrentLocation();
    } else {
      PermissionStatus statuses = await Permission.location.request();
      if (statuses.isGranted) {
        getCurrentLocation();
      } else {
        Util.showMyDialog(
            context: context,
            title: "Thông báo",
            message: "Để sử dụng tính năng này bạn cần cấp quyền cho hệ thống.",
            textActionCancel: "Hủy",
            actionCancel: () {},
            textActionOk: "Ok",
            actionOk: () {
              openAppSettings();
            });
      }
    }
  }

  void getCurrentLocation() {
    LocationUtil.getLastKnownPosition(onSuccess: (position) {
      SearchHistory searchItemView = SearchHistory();
      searchItemView.isUseMyLocation = true;
      searchItemView.lat = position?.latitude;
      searchItemView.lng = position?.longitude;
      searchItemView.searchString = "Vị trí của bạn";
      addItemSearch(searchItemView);

      goToSearchResult();
    }, onError: (ex) {
      Log.e(ex);
    });
  }

  void onClickItemSearchHistory(SearchHistory searchHistory) {
    SearchHistory searchItemView = SearchHistory()
      ..searchId = searchHistory.searchId
      ..resultType = searchHistory.resultType
      ..metaData = searchHistory.metaData
      ..searchString = searchHistory.searchString;
    addItemSearch(searchItemView);
    _searchBloc.add(SaveSearchHistoryEvent(searchHistory, searchItemView));
    goToSearchResult();
  }

  void addItemSearch(SearchHistory searchItemView) {
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
      setState(() {
        listSearchSelected = listSearchSelected;
      });
    }
  }

  void removeItemSearch(int position) {
    listSearchSelected.removeAt(position);
    setState(() {
      listSearchSelected = listSearchSelected;
    });
  }

  void removeAllItemSearch() {
    listSearchSelected = [];
    setState(() {
      listSearchSelected = listSearchSelected;
    });
  }

  Widget _renderHeaderView() {
    return Material(
      elevation: 4,
      color: Colors.white,
      shadowColor: AppColor.dividerGray,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderBackButton(),
          Expanded(
            child: Column(
              children: [
                _renderListItemSearchSelected(),
                Container(
                  child: TextField(
                    maxLines: listSearchSelected.length < 5 ? 1 : 2,
                    style: TextStyle(fontSize: 15, height: Platform.isAndroid ? 1.4 : 1.35),
                    readOnly: listSearchSelected.length >= 5,
                    inputFormatters: [
                      // max length
                      LengthLimitingTextInputFormatter(100),
                    ],
                    onChanged: onSearchTextChanged,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: AppColor.black_40p,
                      ),
                      hintText: listSearchSelected.isEmpty
                          ? "Nhập khu vực bạn muốn tìm kiếm..."
                          : (listSearchSelected.length < 5
                              ? "Tìm thêm khu vực khác"
                              : "Xin lỗi, bạn chỉ có thể tìm kiếm tối đa 5 khu vực"),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          listSearchSelected.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(
                    top: 6,
                    bottom: 6,
                    right: 16,
                  ),
                  padding: EdgeInsets.all(5),
                  width: 30,
                  height: 30,
                  child: InkResponse(
                    radius: 30,
                    onTap: () {
                      removeAllItemSearch();
                    },
                    child: SvgPicture.asset(
                      "assets/images/ic_delete_all_search_selected.svg",
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _renderListDataView(SearchState state) {
    Widget widget;
    if (listSearchSelected.isEmpty) {
      if (textSearch.length < 2) {
        widget = _renderListItemSearchHistory(state);
      } else {
        widget = _renderListItemSearchSuggestion(state);
      }
    } else {
      if (textSearch.length < 2) {
        widget = Container();
      } else {
        widget = _renderListItemSearchSuggestion(state);
      }
    }

    return Expanded(
      child: widget,
    );
  }

  Widget _renderBackButton() {
    return InkWellWithoutRipple(
      onTap: () {
        _searchBloc.listSearchHistory = [];
        _searchBloc.listSearchSuggestion = [];
        Navigator.pop(
          context,
          {
            "listSearchSelected": listSearchSelected,
            "categoryType": widget.categoryType,
          },
        );
      },
      child: Container(
        width: 50,
        height: 40,
        margin: EdgeInsets.only(top: 5),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget _renderListItemSearchSelected() {
    if (listSearchSelected.isEmpty) {
      return Container();
    } else {
      List<Widget> listItem = <Widget>[];
      for (int i = 0; i < listSearchSelected.length; i++) {
        listItem.add(_renderItemSearchSelectedView(i, (position) {
          removeItemSearch(position);
        }));
      }
      return Container(
        width: double.infinity,
        child: Wrap(
          children: listItem,
        ),
      );
    }
  }

  Widget _renderItemSearchSelectedView(int position, Function(int) onDelete) {
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
        vertical: 5,
      ),
      margin: EdgeInsets.only(
        top: 7,
        right: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(searchItemView.searchString.toString()),
          InkResponse(
            radius: 20,
            child: SvgPicture.asset("assets/images/ic_remove_item_search.svg"),
            onTap: () {
              onDelete(position);
            },
          ),
        ],
      ),
    );
  }

  Widget _renderListItemSearchHistory(SearchState state) {
    if (state is LoadingGetSearchHistoryState) {
      return Center(
        child: LoadingView(
          width: 160,
          height: 160,
        ),
      );
    } else {
      if (state is SuccessGetSearchHistoryState) {
        listSearchHistoryRecently = state.data;
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: _renderItemSearchHistory,
        itemCount: listSearchHistoryRecently.length,
      );
    }
  }

  Widget _renderItemSearchHistory(context, position) {
    return Container(
      child: listSearchHistoryRecently.elementAt(position).isFakeLocation == true
          ? _renderItemRowUseMyLocation(context, position)
          : _renderItemRowSearchHistory(context, position),
    );
  }

  Widget _renderItemRowUseMyLocation(context, position) {
    return InkWell(
      onTap: onClickUseMyLocation,
      child: Container(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 25,
          right: 18,
        ),
        child: Row(
          children: [
            Container(
              child: SvgPicture.asset("assets/images/vector_ic_geo.svg"),
              padding: const EdgeInsets.only(right: 10),
            ),
            Expanded(
              child: Text(
                "Vị trí hiện tại của bạn",
                style: TextStyle(
                  color: HexColor("#242933"),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderItemRowSearchHistory(context, position) {
    var element = listSearchHistoryRecently.elementAt(position);
    return InkWell(
      onTap: () {
        onClickItemSearchHistory(element);
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 25,
          right: 18,
        ),
        child: Row(
          children: [
            Container(
              child: SvgPicture.asset("assets/images/vector_ic_clock_history.svg"),
              padding: const EdgeInsets.only(right: 10),
            ),
            Expanded(
              child: Text(
                element.searchString.toString(),
                style: TextStyle(
                  color: HexColor("#242933"),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderViewEmptyListSuggestion() {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 100),
          Lottie.asset(
            'assets/json/empty_searching.json',
            width: 140,
            height: 140,
            repeat: true,
            frameRate: FrameRate.max,
          ),
          SizedBox(height: 20),
          Text(
            "Rất tiếc, không có kết quả nào cho ‘$textSearch’",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: HexColor("363636"),
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Đảm bảo các từ đều đúng chính tả hoặc sử dụng từ khoá khác",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: HexColor("4A4A4A"),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderListItemSearchSuggestion(SearchState state) {
    Widget widget;
    if (state is StartGetLocationAutoCompleteState) {
      widget = Container();
    } else {
      if (state is SuccessGetLocationAutoCompleteState) {
        listSearchSuggestion = state.data;
      }

      widget = listSearchSuggestion.isEmpty == true
          ? _renderViewEmptyListSuggestion()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: _renderItemGroupSearchSuggestion,
              itemCount: listSearchSuggestion.length,
            );
    }
    return widget;
  }

  Widget _renderItemGroupSearchSuggestion(context, position) {
    SearchGroupSuggestion item = listSearchSuggestion[position];
    if (item.group == null || item.list == null || item.list!.isEmpty) {
      return Container();
    } else {
      String iconPath = "";
      String group = "";
      if (SearchGroupType.STREET.type == item.group) {
        iconPath = "assets/images/ic_street_search_suggestion.svg";
        group = "Tuyến đường";
      } else if (SearchGroupType.ZONE.type == item.group) {
        iconPath = "assets/images/ic_zone_search_suggestion.svg";
        group = "Khu vực";
      } else if (SearchGroupType.PROJECT.type == item.group) {
        iconPath = "assets/images/ic_project_search_suggestion.svg";
        group = "Dự án";
      } else {
        iconPath = "assets/images/ic_propzy_home_search_suggestion.svg";
        group = "Propzy Home";
      }
      return Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 20,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 7),
                      child: Text(
                        group,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: HexColor("242933"),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _renderListAddressSuggestion(position)
          ],
        ),
      );
    }
  }

  Widget _renderListAddressSuggestion(position) {
    SearchGroupSuggestion item = listSearchSuggestion[position];
    List<Widget> listItemAddressSuggestionWidget = <Widget>[];
    for (int i = 0; i < item.list!.length; i++) {
      listItemAddressSuggestionWidget.add(_renderItemAddressSuggestion(item, i));
      if (i < item.list!.length - 1) {
        // add separator
        listItemAddressSuggestionWidget.add(
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 50,
              right: 10,
            ),
            child: SvgPicture.asset(
              "assets/images/dash_line_search_suggestion.svg",
              width: double.infinity,
              height: 3,
            ),
          ),
        );
      }
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listItemAddressSuggestionWidget,
      ),
    );
  }

  Widget _renderItemAddressSuggestion(SearchGroupSuggestion item, int position) {
    SearchAddressSuggestion? itemAddress = item.list?.elementAt(position);
    if (SearchGroupType.STREET.type == item.group || SearchGroupType.ZONE.type == item.group) {
      return InkWell(
        onTap: () {
          onClickOnItemAddressSuggestion(item, position);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 50,
            top: 10,
            bottom: 10,
            right: 20,
          ),
          child: Text(
            "${itemAddress?.display}",
            style: TextStyle(
              color: HexColor("4A4A4A"),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    } else if (SearchGroupType.PROJECT.type == item.group) {
      return InkWell(
        onTap: () {
          onClickOnItemAddressSuggestion(item, position);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 50,
            top: 10,
            bottom: 10,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${itemAddress?.projectName}",
                style: TextStyle(
                  color: HexColor("4A4A4A"),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: Text(
                  "${itemAddress?.address}",
                  style: TextStyle(
                    color: HexColor("6A6D74"),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          onClickOnItemAddressSuggestion(item, position);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 50,
            top: 10,
            bottom: 10,
            right: 20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "${itemAddress?.address}",
                  style: TextStyle(
                    color: HexColor("4A4A4A"),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 50),
                margin: EdgeInsets.only(left: 10),
                child: Center(
                  child: Text(
                    "${itemAddress?.formatPriceVnd}",
                    style: TextStyle(
                      color: HexColor("F17423"),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void onClickOnItemAddressSuggestion(SearchGroupSuggestion item, int position) {
    SearchAddressSuggestion searchAddressSuggestion = item.list![position];
    if (item.group == SearchGroupType.PROPZY_HOME.type) {
      NavigationController.navigateToListingDetail(context, searchAddressSuggestion.id);
    } else if (item.group == SearchGroupType.PROJECT.type) {
      NavigationController.navigateToKeyCondo(context, searchAddressSuggestion.id?.toString());
    } else {
      SearchHistory searchItemView = SearchHistory();
      searchItemView.metaData = searchAddressSuggestion.metaData;
      searchItemView.resultType = searchAddressSuggestion.resultType;
      searchItemView.searchId = searchAddressSuggestion.id;
      if (item.group == SearchGroupType.STREET.type) {
        searchItemView.searchString = searchAddressSuggestion.metaData?.streetName;
      } else if (item.group == SearchGroupType.ZONE.type) {
        if (SearchResultType.CITY.type == searchAddressSuggestion.resultType) {
          searchItemView.searchString = searchAddressSuggestion.metaData?.cityName;
        } else if (SearchResultType.DISTRICT.type == searchAddressSuggestion.resultType) {
          searchItemView.searchString = searchAddressSuggestion.metaData?.districtName;
        } else if (SearchResultType.WARD.type == searchAddressSuggestion.resultType) {
          searchItemView.searchString = searchAddressSuggestion.metaData?.wardName;
        } else {
          searchItemView.searchString = searchAddressSuggestion.display;
        }
      }

      addItemSearch(searchItemView);

      SearchHistory searchHistory = SearchHistory();
      searchHistory.group = item.group;
      searchHistory.resultType = searchAddressSuggestion.resultType;
      searchHistory.searchId = searchAddressSuggestion.id;
      searchHistory.metaData = searchAddressSuggestion.metaData;
      searchHistory.searchString = searchItemView.searchString;
      _searchBloc.add(SaveSearchHistoryEvent(searchHistory, searchItemView));
      goToSearchResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider(create: (BuildContext context) => _searchBloc);
    return BlocConsumer<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            _searchBloc.listSearchHistory = [];
            _searchBloc.listSearchSuggestion = [];
            return true;
          },
          child: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      _renderHeaderView(),
                      _renderListDataView(state),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        // if (state is ErrorSaveSearchHistoryState) {
        //   Util.showMyDialog(
        //     context: context,
        //     message: state.errorMessage ?? MessageUtil.errorMessageDefault,
        //   );
        // }
      },
    );
  }

  void goToSearchResult() {
    Navigator.pop(context, {
      "listSearchSelected": listSearchSelected,
      "categoryType": widget.categoryType,
    });
  }
}
