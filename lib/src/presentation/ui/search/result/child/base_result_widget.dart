import 'package:flutter/material.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';

abstract class BaseResultWidget extends StatefulWidget {
  BaseResultWidget({
    Key? key,
    required this.isFirstRunTime,
    required this.onTypeChange,
    required this.listSearchSelected,
    required this.request,
  }) : super(key: key);

  final Function(CategorySearchRequest request, List<SearchHistory> listAddress) onTypeChange;

  final bool isFirstRunTime;

  final List<SearchHistory> listSearchSelected;
  final CategorySearchRequest request;
}
