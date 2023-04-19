import 'package:flutter/src/widgets/framework.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_event.dart';
import 'package:propzy_home/src/presentation/ui/search/result/empty/base_empty_search.dart';
import 'package:propzy_home/src/util/constants.dart';

class BuyEmptySearchView extends EmptySearchView {
  BuyEmptySearchView({required BaseResultBloc parentBloc}) : super(parentBloc: parentBloc);

  @override
  Widget? buildAmenityView() {
    final advantageIds = parentBloc.categoryRequest.advantageIds?.map((e) => e).toList();
    advantageIds?.removeWhere((e) => e?.name == null || e?.isChecked == false);
    if (advantageIds != null) {
      final text = advantageIds.map((e) => e?.name).join(", ");
      return renderItemSearchSelectedView(text, ResetAdvantageEvent());
    }
    return null;
  }

  @override
  Widget? buildStatusView() {
    final status = parentBloc.categoryRequest.statusIds?.first;
    if (status == Constants.CATEGORY_FILTER_STATUS_SOLD_OR_RENT) {
      return renderItemSearchSelectedView('Đã bán', ResetStatusEvent());
    }
    return null;
  }
}
