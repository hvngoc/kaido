import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';
import 'package:propzy_home/src/presentation/ui/search/result/child/buy_result_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/result/child/project_result_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/result/child/rent_result_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/result/next_visit/next_visit_event.dart';
import 'package:propzy_home/src/presentation/ui/search/result/next_visit/next_visit_state.dart';
import 'package:propzy_home/src/presentation/ui/search/result/next_visit/next_vist_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/result/search_result_screen.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';

class SearchResultState extends State<SearchResult> {
  CategorySearchRequest request = CategorySearchRequest(
    categoryType: CategoryType.BUY,
    listingTypeId: CategoryType.BUY.type,
  );
  List<SearchHistory> listSearchSelected = [];
  bool isFirstRunTime = true;

  final NextVisitBloc nextVisitBloc = NextVisitBloc();

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    if (event != null) {
      final next = NextSearchEvent(
          districtId: event.districtId,
          priceTo: event.priceTo,
          priceFrom: event.priceFrom,
          propertyTypeId: event.propertyTypeId);
      nextVisitBloc.add(next);
    } else {
      nextVisitBloc.add(NextLocalEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => nextVisitBloc,
      child: BlocConsumer<NextVisitBloc, NextVisitState>(
        bloc: nextVisitBloc,
        listener: (context, state) {
          if (state is NextVisitSuccess) {
            int type = state.type;
            CategoryType category = CategoryType.fromValue(type);
            request
              ..categoryType = category
              ..listingTypeId = type == CategoryType.PROJECT.type ? CategoryType.BUY.type : type;
          } else if (state is NextSearchSuccess) {
            request
              ..categoryType = CategoryType.BUY
              ..listingTypeId = CategoryType.BUY.type
              ..maxPrice = state.priceTo?.toDouble()
              ..minPrice = state.priceFrom?.toDouble()
              ..propertyTypeIds = state.properties;
          }
        },
        builder: (context, state) {
          if (state is NextVisitLoading) {
            return Center(
              child: LoadingView(
                width: 160,
                height: 160,
              ),
            );
          }
          if (state is NextVisitSuccess || state is NextSearchSuccess) {
            if (request.categoryType.type == CategoryType.BUY.type) {
              return BuyResultWidget(
                isFirstRunTime: isFirstRunTime,
                onTypeChange: _refreshType,
                listSearchSelected: listSearchSelected,
                request: request,
              );
            } else if (request.categoryType.type == CategoryType.RENT.type) {
              return RentResultWidget(
                isFirstRunTime: isFirstRunTime,
                onTypeChange: _refreshType,
                listSearchSelected: listSearchSelected,
                request: request,
              );
            } else {
              return ProjectResultWidget(
                isFirstRunTime: isFirstRunTime,
                onTypeChange: _refreshType,
                listSearchSelected: listSearchSelected,
                request: request,
              );
            }
          }
          return Container();
        },
      ),
    );
  }

  void _refreshType(CategorySearchRequest request, List<SearchHistory> listAddress) {
    setState(() {
      this.isFirstRunTime = false;
      this.request = request;
      listSearchSelected = listAddress;
    });
  }
}
