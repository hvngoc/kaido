import 'package:flutter/material.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';
import 'package:propzy_home/src/presentation/ui/search/result/child/base_result_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/result/child/project_result_state.dart';

class ProjectResultWidget extends BaseResultWidget {
  ProjectResultWidget({
    required bool isFirstRunTime,
    required Function(CategorySearchRequest request, List<SearchHistory> listAddress) onTypeChange,
    required List<SearchHistory> listSearchSelected,
    required CategorySearchRequest request,
  }) : super(
            isFirstRunTime: isFirstRunTime,
            onTypeChange: onTypeChange,
            listSearchSelected: listSearchSelected,
            request: request);

  @override
  State<StatefulWidget> createState() => SearchProjectState();
}
