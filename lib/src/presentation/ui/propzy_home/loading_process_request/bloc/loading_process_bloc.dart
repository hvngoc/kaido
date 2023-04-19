import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';

part 'loading_process_event.dart';
part 'loading_process_state.dart';

class LoadingProcessBloc extends Bloc<LoadingProcessEvent, LoadingProcessState> {
  final useCase = GetIt.I.get<GetOfferPriceUseCase>();

  LoadingProcessBloc() : super(LoadingProcessInitial()) {
    on<GetOfferPriceEvent>(_getOfferPrice);
  }

  FutureOr<void> _getOfferPrice(GetOfferPriceEvent event, Emitter<LoadingProcessState> emit) async {
    emit(LoadingProcessInitial());
    final response = await useCase.getOfferPrice(event.offerId);
    if (response.result == true) {
      emit(GetOfferStatusSuccess(response.data?.status ?? ''));
    } else {
      emit(GetOfferStatusError());
    }
  }
}
