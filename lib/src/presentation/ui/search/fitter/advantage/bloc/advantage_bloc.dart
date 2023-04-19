import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/common_model.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/advantage/advantage.dart';

import '../../../../../../domain/usecase/filter/get_advantage_category_list_usecase.dart';

part 'advantage_event.dart';

part 'advantage_state.dart';

class AdvantageBloc extends Bloc<AdvantageEvent, AdvantageState> {
  AdvantageBloc() : super(AdvantageInitial()) {
    on<LoadAdvantageEvent>(_getAdvantage);
    on<CheckItemAdvantageEvent>(_checkItem);
    on<CheckAllAdvantageEvent>(_checkAll);
    on<ResetAdvantageEvent>(_resetFilter);
  }

  final advantageUseCase = GetIt.I<GetAdvantageCategoryListUseCase>();

  FutureOr<void> _getAdvantage(
      LoadAdvantageEvent event, Emitter<AdvantageState> emit) async {
    if (event.advantage != null) {
      emit(AdvantageLoaded(data: event.advantage));
      return;
    }
    final result = await advantageUseCase.call(NoParams());
    result.fold(
      (l) => emit(AdvantageError()),
      (advantageList) => emit(AdvantageLoaded(data: advantageList)),
    );
  }

  FutureOr<void> _checkItem(
      CheckItemAdvantageEvent event, Emitter<AdvantageState> emit) {
    if ((state is AdvantageLoaded)) {
      final previousData = (state as AdvantageLoaded).data;
      final itemTmp = event.item;
      itemTmp?.isChecked = !(event.item?.isChecked ?? false);
      previousData?[event.index] = itemTmp;
      emit(AdvantageLoaded().copyWith(data: previousData));
    }
  }

  FutureOr<void> _checkAll(
      CheckAllAdvantageEvent event, Emitter<AdvantageState> emit) {
    final currentState = state as AdvantageLoaded;
    if (currentState.isCheckedAll()) {
      final newData = currentState.data?.map((e) {
        e?.isChecked = false;
        return e;
      }).toList();
      emit(AdvantageLoaded().copyWith(data: newData));
    } else {
      final newData = currentState.data?.map((e) {
        e?.isChecked = true;
        return e;
      }).toList();
      emit(AdvantageLoaded().copyWith(data: newData));
    }
  }

  FutureOr<void> _resetFilter(
      ResetAdvantageEvent event, Emitter<AdvantageState> emit) {
    final currentState = state as AdvantageLoaded;
    final newData = currentState.data?.map((e) {
      e?.isChecked = false;
      return e;
    }).toList();

    emit(AdvantageLoaded().copyWith(data: newData));
  }
}
