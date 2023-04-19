import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';
import 'package:propzy_home/src/domain/usecase/filter/get_bathroom_list_usecase.dart';

import '../../../../../../domain/model/common_model_1.dart';

part 'bathroom_event.dart';

part 'bathroom_state.dart';

class BathroomBloc extends Bloc<BathroomEvent, BathroomState> {
  BathroomBloc() : super(BathroomInitial()) {
    on<LoadBathRoomEvent>(_getBathRoomList);
    on<CheckItemBathroomEvent>(_checkItem);
    on<ResetFilterBathRoomEvent>(_resetFilter);
  }

  final getBathRoomListUseCase = GetIt.I<GetBathRoomListUseCase>();

  FutureOr<void> _getBathRoomList(LoadBathRoomEvent event, Emitter<BathroomState> emit) async {
    final result = await getBathRoomListUseCase.call(NoParams());
    result.fold(
      (l) => emit(BathroomError()),
      (r) {
        if(event.itemSelected?.id != null){
          r?.firstWhere((element) => element.id == event.itemSelected?.id).isSelected = true;
        }
        else {
          r?.first.isSelected = true;
        }
        emit(BathroomLoaded(data: r));
      }
    );
  }

  FutureOr<void> _checkItem(CheckItemBathroomEvent event, Emitter<BathroomState> emit) {
    if (state is BathroomLoaded) {
      final currentListData = (state as BathroomLoaded).data;
      int index = currentListData?.indexWhere((element) => element?.isSelected == true) ?? 0;

      if (index != event.index) {
        List<BathRoom?>? previousData =
            (state as BathroomLoaded).data?.map((e) => BathRoom.clone(e)).toList();
        previousData?.forEach((element) {
          element?.isSelected = event.item?.id == element.id;
        });

        emit(BathroomLoaded().copyWith(data: previousData));
      }
    }
  }

  FutureOr<void> _resetFilter(ResetFilterBathRoomEvent event, Emitter<BathroomState> emit) {
    if (state is BathroomLoaded) {
      final currentListData = (state as BathroomLoaded).data;
      currentListData?.firstWhere((element) => element?.isSelected == true)?.isSelected = false;
      currentListData?.first?.isSelected = true;
      emit(BathroomLoaded().copyWith(data: currentListData));
    }
  }
}
