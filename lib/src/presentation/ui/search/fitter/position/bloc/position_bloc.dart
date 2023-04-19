import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';
import 'package:propzy_home/src/domain/usecase/filter/get_position_list_usecase.dart';

import '../../../../../../domain/model/common_model_1.dart';

part 'position_event.dart';

part 'position_state.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  PositionBloc() : super(PositionInitial()) {
    on<LoadPositionEvent>(_getPositionList);
    on<CheckItemPositionEvent>(_checkItem);
    on<ResetAllPositionEvent>(_resetFilter);
  }

  final getPositionListUseCase = GetIt.I<GetPositionListUseCase>();

  FutureOr<void> _getPositionList(LoadPositionEvent event,
      Emitter<PositionState> emit) async {
    final result = await getPositionListUseCase.call(NoParams());
    result.fold(
            (l) => emit(PositionError()),
            (r) {
          final Position? currentPosition = event.currentPosition;
          if (currentPosition?.id != null) {
            r
                ?.firstWhere((element) => element.id == currentPosition?.id)
                .isSelected = true;
          }
          else {
            r?.first.isSelected = true;
          }
          emit(PositionLoaded(data: r));
        }
    );
  }

  FutureOr<void> _checkItem(CheckItemPositionEvent event,
      Emitter<PositionState> emit) {
    if (state is PositionLoaded) {
      final currentListData = (state as PositionLoaded).data;
      int index = currentListData?.indexWhere((element) =>
      element?.isSelected == true) ?? 0;

      if (index != event.index) {
        List<Position?>? previousData =
        (state as PositionLoaded).data?.map((e) => Position.clone(e)).toList();
        previousData?.forEach((element) {
          element?.isSelected = event.item?.id == element.id;
        });

        emit(PositionLoaded().copyWith(data: previousData));
      }
    }
  }

  FutureOr<void> _resetFilter(ResetAllPositionEvent event,
      Emitter<PositionState> emit) {
    if (state is PositionLoaded) {
      final currentListData = (state as PositionLoaded).data;
      currentListData
          ?.firstWhere((element) => element?.isSelected == true)
          ?.isSelected = false;
      currentListData?.first?.isSelected = true;
      emit(PositionLoaded().copyWith(data: currentListData));
    }
  }
}
