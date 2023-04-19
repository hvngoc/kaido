import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';
import 'package:propzy_home/src/domain/usecase/filter/get_bedroom_list_usecase.dart';

import '../../../../../../domain/model/common_model_1.dart';

part 'bedroom_event.dart';

part 'bedroom_state.dart';

class BedroomBloc extends Bloc<BedroomEvent, BedroomState> {
  BedroomBloc() : super(BedroomInitial()) {
    on<LoadBedRoomEvent>(_getBedRoomList);
    on<CheckItemBedroomEvent>(_checkItem);
    on<ResetFilterBedRoomEvent>(_resetFilter);

  }

  final getBedRoomListUseCase = GetIt.I<GetBedRoomListUseCase>();

  FutureOr<void> _getBedRoomList(LoadBedRoomEvent event, Emitter<BedroomState> emit) async {
    final result = await getBedRoomListUseCase.call(NoParams());
    result.fold(
      (l) => emit(BedroomError()),
      (bedRoomList) {
        if(event.itemSelected?.id != null){
          bedRoomList?.firstWhere((element) => element.id == event.itemSelected?.id).isSelected = true;
        }else {
          bedRoomList?.first.isSelected = true;
        }
        emit(BedroomLoaded(data: bedRoomList));
      }
    );
  }

  FutureOr<void> _checkItem(CheckItemBedroomEvent event, Emitter<BedroomState> emit) {
    if (state is BedroomLoaded) {
      final currentListData = (state as BedroomLoaded).data;
      int index = currentListData?.indexWhere((element) => element?.isSelected == true) ?? 0;

      if (index != event.index) {
        List<BedRoom?>? previousData =
        (state as BedroomLoaded).data?.map((e) => BedRoom.clone(e)).toList();
        previousData?.forEach((element) {
          element?.isSelected = event.item?.id == element.id;
        });

        emit(BedroomLoaded().copyWith(data: previousData));
      }
    }
  }

  FutureOr<void> _resetFilter(ResetFilterBedRoomEvent event, Emitter<BedroomState> emit) {
    if (state is BedroomLoaded) {
      final currentListData = (state as BedroomLoaded).data;
      currentListData?.firstWhere((element) => element?.isSelected == true)?.isSelected = false;
      currentListData?.first?.isSelected = true;
      emit(BedroomLoaded().copyWith(data: currentListData));
    }
  }
}
