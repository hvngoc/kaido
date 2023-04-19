import 'package:flutter/src/widgets/framework.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_event.dart';
import 'package:propzy_home/src/presentation/ui/search/result/empty/base_empty_search.dart';
import 'package:propzy_home/src/util/constants.dart';

class RentEmptySearchView extends EmptySearchView {
  RentEmptySearchView({required BaseResultBloc parentBloc}) : super(parentBloc: parentBloc);

  @override
  Widget? buildAmenityView() {
    final amenityIds = parentBloc.categoryRequest.amenityIds?.map((e) => e).toList();
    amenityIds?.removeWhere((e) => e?.name == null || e?.isChecked == false);
    if (amenityIds != null) {
      final text = amenityIds.map((e) => e?.name).join(", ");
      return renderItemSearchSelectedView(text, ResetAmenityEvent());
    }
    return null;
  }

  @override
  Widget? buildStatusView() {
    final status = parentBloc.categoryRequest.statusIds?.first;
    if (status == Constants.CATEGORY_FILTER_STATUS_SOLD_OR_RENT) {
      return renderItemSearchSelectedView('Đã thuê', ResetStatusEvent());
    }
    return null;
  }
}
