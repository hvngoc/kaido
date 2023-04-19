import 'package:flutter/src/widgets/framework.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_event.dart';
import 'package:propzy_home/src/presentation/ui/search/result/empty/base_empty_search.dart';
import 'package:propzy_home/src/util/constants.dart';

class ProjectEmptySearchView extends EmptySearchView {
  ProjectEmptySearchView({required BaseResultBloc parentBloc}) : super(parentBloc: parentBloc);

  @override
  Widget? buildAmenityView() => null;

  @override
  Widget? buildStatusView() {
    final status = parentBloc.categoryRequest.statusIds?.first;
    if (status == Constants.CATEGORY_FILTER_STATUS_SOON) {
      return renderItemSearchSelectedView(Constants.CATEGORY_NAME_SOON, ResetStatusEvent());
    } else if (status == Constants.CATEGORY_FILTER_STATUS_COMPLETE) {
      return renderItemSearchSelectedView(Constants.CATEGORY_NAME_COMPLETE, ResetStatusEvent());
    }
    return null;
  }
}
