import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_property/bloc/choose_property_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_property/bloc/choose_property_state.dart';
import 'package:propzy_home/src/util/util.dart';

class ChoosePropertyBloc extends Bloc<ChoosePropertyEvent, ChoosePropertyState> {
  final UpdateCategoryListingUseCase updateUseCase =
      GetIt.instance.get<UpdateCategoryListingUseCase>();

  ChoosePropertyBloc() : super(ChoosePropertyInitial()) {
    on<ChoosePropertyEvent>(_submitProperties);
  }

  FutureOr<void> _submitProperties(ChoosePropertyEvent e, Emitter<ChoosePropertyState> emit) async {
    Util.showLoading();
    final result = await updateUseCase.updateCategory(e.id, e.listingTypeId, e.propertyTypeId);
    Util.hideLoading();
    result.fold(
      (l) => emit(ChoosePropertyLoading()),
      (r) {
        emit(ChoosePropertySuccess());
      },
    );
  }
}
