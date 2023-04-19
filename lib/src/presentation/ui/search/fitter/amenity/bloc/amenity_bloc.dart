import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/common_model.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';

import '../../../../../../domain/usecase/filter/get_amenity_category_list_usecase.dart';

part 'amenity_event.dart';
part 'amenity_state.dart';

class AmenityBloc extends Bloc<AmenityEvent, UtilitiesState> {
  AmenityBloc() : super(AmenityInitial()) {
    on<LoadAmenityEvent>(_getAmenity);
    on<CheckItemAmenityEvent>(_checkItem);
    on<CheckAllAmenityEvent>(_checkAll);
    on<ResetFilterAmenityEvent>(_resetFilter);
  }

  final amenityUseCase = GetIt.I<GetAmenityCategoryListUseCase>();

  FutureOr<void> _getAmenity(
      LoadAmenityEvent event, Emitter<UtilitiesState> emit) async {
    if(event.amenity != null){
      emit(AmenityLoaded(data: event.amenity));
      return;
    }
    final result = await amenityUseCase.call(NoParams());
    result.fold(
      (l) => emit(AmenityError()),
      (directionList) => emit(AmenityLoaded(data: directionList)),
    );
  }

  FutureOr<void> _checkItem(
      CheckItemAmenityEvent event, Emitter<UtilitiesState> emit) {
    if ((state is AmenityLoaded)) {
      final previousData = (state as AmenityLoaded).data;
      final itemTmp = event.item;
      itemTmp?.isChecked = !(event.item?.isChecked ?? false);
      previousData?[event.index] = itemTmp;
      emit(AmenityLoaded().copyWith(data: previousData));
    }
  }

  FutureOr<void> _checkAll(
      CheckAllAmenityEvent event, Emitter<UtilitiesState> emit) {
    final currentState = state as AmenityLoaded;
    if (currentState.isCheckedAll()) {
      final newData = currentState.data?.map((e) {
        e?.isChecked = false;
        return e;
      }).toList();
      emit(AmenityLoaded().copyWith(data: newData));
    } else {
      final newData = currentState.data?.map((e) {
        e?.isChecked = true;
        return e;
      }).toList();
      emit(AmenityLoaded().copyWith(data: newData));
    }
  }

  FutureOr<void> _resetFilter(
      ResetFilterAmenityEvent event, Emitter<UtilitiesState> emit) {
    final currentState = state as AmenityLoaded;
      final newData = currentState.data?.map((e) {
        e?.isChecked = false;
        return e;
      }).toList();
      emit(AmenityLoaded().copyWith(data: newData));
  }
}
