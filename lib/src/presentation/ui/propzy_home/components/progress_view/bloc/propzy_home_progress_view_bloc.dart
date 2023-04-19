import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';

part 'propzy_home_progress_view_event.dart';
part 'propzy_home_progress_view_state.dart';

class PropzyHomeProgressViewBloc extends Bloc<PropzyHomeProgressViewEvent, PropzyHomeProgressViewState> {
  final useCase = GetIt.instance.get<GetCompletionPercentageUseCase>();

  PropzyHomeProgressViewBloc() : super(PropzyHomeProgressViewInitial()) {
    on<GetCompletionPercentageEvent>(_getOfferPrice);
  }

  int? offerId;
  double? totalPercent;

  FutureOr<void> _getOfferPrice(GetCompletionPercentageEvent event, Emitter<PropzyHomeProgressViewState> emit) async {
    emit(PropzyHomeProgressViewInitial());
    final response = await useCase.getCompletionPercentage(event.offerId);
    offerId = event.offerId;
    if (response.result == true) {
      totalPercent = response.data?.totalPercent;
      emit(GetCompletionPercentageSuccess(response.data?.totalPercent ?? 0));
    } else {
      emit(GetCompletionPercentageFail());
    }
  }
}
