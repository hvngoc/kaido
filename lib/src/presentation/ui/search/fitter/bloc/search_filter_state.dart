import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/presentation/ui/search/result/child/buy_result_state.dart';

abstract class SearchFilterState {}

class InitDataState extends SearchFilterState {
  InitDataState({this.data});

  final PagingResponse? data;
}

class ResetFilterState extends SearchFilterState{}
