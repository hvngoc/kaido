import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/ui/home/home_event.dart';
import 'package:propzy_home/src/presentation/ui/search/result/search_result_state.dart';

class SearchResult extends StatefulWidget {
  final GoToSearchEvent? event;

  SearchResult({Key? key, this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchResultState();
  }
}
