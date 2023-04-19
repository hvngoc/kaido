import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_process_model.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';

part 'propzy_home_process_view_event.dart';
part 'propzy_home_process_view_state.dart';

class PropzyHomeProcessViewBloc extends Bloc<PropzyHomeProcessViewEvent, PropzyHomeProcessViewState> {
  final useCase = GetIt.instance.get<GetProcessOfferUseCase>();

  PropzyHomeProcessViewBloc() : super(PropzyHomeProcessViewInitial()) {
    on<GetProcessOfferEvent>(_getProcessOffer);
  }

  FutureOr<void> _getProcessOffer(GetProcessOfferEvent event, Emitter<PropzyHomeProcessViewState> emit) async {
    emit(PropzyHomeProcessViewInitial());
    final response = await useCase.getProcessOffer(event.offerId);
    if (response.result == true) {
      emit(GetProcessOfferSuccess(response.data ?? []));
    } else {
      emit(GetProcessOfferFail());
    }
  }
}
