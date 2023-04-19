import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/plan_to_buy/bloc/plan_to_buy_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/plan_to_buy/bloc/plan_to_buy_state.dart';
import 'package:propzy_home/src/util/util.dart';

class PlanToBuyBloc extends Bloc<PlanToBuyEvent, BasePlanToBuyState> {
  final GetListPlanToBuyServicesUseCase getListPlanUseCase =
      GetIt.instance.get<GetListPlanToBuyServicesUseCase>();

  final UpdatePlanToBuyListingUseCase updateUseCase =
      GetIt.instance.get<UpdatePlanToBuyListingUseCase>();

  List<HomeDirection>? listData;

  PlanToBuyBloc() : super(PlanToBuyStateInitial()) {
    on<LoadListPlanEvent>(_getListQuo);
    on<UpdatePlanToBuyEvent>(_updateRequest);
  }

  Future<FutureOr<void>> _getListQuo(PlanToBuyEvent e, Emitter<BasePlanToBuyState> emit) async {
    final res = await getListPlanUseCase.getList();
    res.fold(
      (l) {
        emit(PlanToBuyStateLoading());
      },
      (r) {
        listData = r;
        emit(PlanToBuyStateSuccess(false));
      },
    );
  }

  Future<FutureOr<void>> _updateRequest(
      UpdatePlanToBuyEvent e, Emitter<BasePlanToBuyState> emit) async {
    Util.showLoading();
    final result = await updateUseCase.update(
      e.id,
      e.buyPlanOptionId,
      e.districtId,
      e.priceFrom,
      e.priceTo,
      e.propertyTypeId,
    );
    Util.hideLoading();
    result.fold(
      (l) => emit(PlanToBuyStateInitial()),
      (r) {
        emit(PlanToBuyStateSuccess(true));
      },
    );
  }
}
