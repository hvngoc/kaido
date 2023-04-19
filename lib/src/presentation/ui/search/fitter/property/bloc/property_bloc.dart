import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/usecase/filter/get_property_type_list_usecase.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';

import '../../../../../../domain/model/property_type_model.dart';
import '../../../../../../domain/usecase/filter/get_property_type_list_project_use_case.dart';

part 'property_event.dart';

part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyBloc() : super(PropertyInitial()) {
    on<LoadPropertyEvent>(_getProperty);
    on<CheckItemPropertyEvent>(_checkItem);
    on<CheckAllPropertyEvent>(_checkAll);
    on<ResetAllPropertyEvent>(_resetFilter);
  }

  final propertyUseCase = GetIt.I<GetPropertyTypeListUseCase>();
  final propertyTypeProjectUseCase = GetIt.I<GetPropertyTypeListProjectUseCase>();

  FutureOr<void> _getProperty(LoadPropertyEvent event, Emitter<PropertyState> emit) async {
    if(event.propertyType != null){
      emit(PropertyLoaded(data: event.propertyType));
      return;
    }
      final result = event.categoryType == CategoryType.PROJECT ? await propertyTypeProjectUseCase.call(event.listingTypeId) :
      await propertyUseCase.call(event.listingTypeId);
      result.fold(
            (l) => emit(PropertyError()),
            (propertyList) => emit(PropertyLoaded(data: propertyList)),
      );
  }

  FutureOr<void> _checkItem(CheckItemPropertyEvent event, Emitter<PropertyState> emit) {
    if (state is PropertyLoaded) {
      final previousData = (state as PropertyLoaded).data;
      final itemTmp = event.item;
      itemTmp?.isChecked = !(event.item?.isChecked ?? false);
      previousData?[event.index] = itemTmp;
      emit(PropertyLoaded().copyWith(data: previousData));
    }
  }

  FutureOr<void> _checkAll(CheckAllPropertyEvent event, Emitter<PropertyState> emit) {
    final currentState = state as PropertyLoaded;
    if (currentState.isCheckedAll()) {
      final newData = currentState.data?.map((e) {
        e?.isChecked = false;
        return e;
      }).toList();
      emit(PropertyLoaded().copyWith(data: newData));
    } else {
      final newData = currentState.data?.map((e) {
        e?.isChecked = true;
        return e;
      }).toList();
      emit(PropertyLoaded().copyWith(data: newData));
    }
  }

  FutureOr<void> _resetFilter(ResetAllPropertyEvent event, Emitter<PropertyState> emit) {
    final currentState = state as PropertyLoaded;
    final newData = currentState.data?.map((e) {
      e?.isChecked = false;
      return e;
    }).toList();
      emit(PropertyLoaded().copyWith(data: newData));
    }
}
