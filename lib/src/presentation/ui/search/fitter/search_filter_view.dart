import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/filter_main_page.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'bloc/search_filter_bloc.dart';

class SearchFilterView extends StatelessWidget {
  SearchFilterView({
    Key? key,
    required this.searchRequest,
    required this.listSearchSelected,
    required this.initTotalElement,
  }) : super(key: key);

  final CategorySearchRequest searchRequest;
  final List<SearchHistory> listSearchSelected;
  final int initTotalElement;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityProvider(
      child: BlocProvider(
        create: (_) => SearchFilterBloc(searchRequest),
        child: FilterMainPage(
          searchRequest: searchRequest,
          listSearchSelected: listSearchSelected,
          initTotalElement: initTotalElement,
        ),
      ),
    );
  }
}
