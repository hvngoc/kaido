import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/common_model.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/position/position.dart';

import '../../../../../../domain/usecase/filter/get_direction_list_usecase.dart';

part 'direction_event.dart';
part 'direction_state.dart';

class DirectionBloc extends Bloc<DirectionEvent, DirectionState> {
  DirectionBloc() : super(DirectionInitial()) {
    on<LoadDirectionEvent>(_getProperty);
    on<CheckItemDirectionEvent>(_checkItem);
    on<CheckAllDirectionEvent>(_checkAll);
    on<ResetAllDirectionEvent>(_resetFilter);
  }

  final directionUseCase = GetIt.I<GetDirectionListUseCase>();

  FutureOr<void> _getProperty(
      LoadDirectionEvent event, Emitter<DirectionState> emit) async {
    if(event.direction != null){
      emit(DirectionLoaded(data: event.direction));
      return;
    }
    final result = await directionUseCase.call(NoParams());
      result.fold(
            (l) => emit(DirectionError()),
            (directionList) => emit(DirectionLoaded(data: directionList)),
      );
    }

  FutureOr<void> _checkItem(
      CheckItemDirectionEvent event, Emitter<DirectionState> emit) {
    if ((state is DirectionLoaded)) {
      final previousData = (state as DirectionLoaded).data;
      final itemTmp = event.item;
      itemTmp?.isChecked = !(event.item?.isChecked ?? false);
      previousData?[event.index] = itemTmp;
      emit(DirectionLoaded().copyWith(data: previousData));
    }
  }

  FutureOr<void> _checkAll(
      CheckAllDirectionEvent event, Emitter<DirectionState> emit) {
    final currentState = state as DirectionLoaded;
    if (currentState.isCheckedAll()) {
      final newData = currentState.data?.map((e) {
        e?.isChecked = false;
        return e;
      }).toList();
      emit(DirectionLoaded().copyWith(data: newData));
    } else {
      final newData = currentState.data?.map((e) {
        e?.isChecked = true;
        return e;
      }).toList();
      emit(DirectionLoaded().copyWith(data: newData));
    }
  }

  FutureOr<void> _resetFilter(ResetAllDirectionEvent event, Emitter<DirectionState> emit) {
    final currentState = state as DirectionLoaded;
    final newData = currentState.data?.map((e) {
      e?.isChecked = false;
      return e;
    }).toList();
    emit(DirectionLoaded().copyWith(data: newData));
  }
}
