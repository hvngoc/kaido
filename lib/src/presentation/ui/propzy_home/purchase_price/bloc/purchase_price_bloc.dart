import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';

part 'purchase_price_event.dart';

part 'purchase_price_state.dart';

class PurchasePriceBloc extends Bloc<PurchasePriceEvent, PurchasePriceState> {
  final getOfferDetailUseCase = GetIt.I.get<GetOfferDetailUseCase>();
  final callScheduleOfferUseCase = GetIt.I.get<CallScheduleOfferUseCase>();

  HomeOfferModel? offerModel;
  int? offerId;

  PurchasePriceBloc() : super(PurchasePriceLoading()) {
    on<GetOfferDetailEvent>(_getOfferDetail);
    on<CallScheduleOfferEvent>(_scheduleOffer);
  }

  FutureOr<void> _getOfferDetail(
    GetOfferDetailEvent event,
    Emitter<PurchasePriceState> emit,
  ) async {
    final response = await getOfferDetailUseCase.call(event.offerId);
    response.fold(
      (l) => emit(PurchasePriceLoading()),
      (r) {
        offerId = event.offerId;
        offerModel = r;
        emit(PurchasePriceGetOfferSuccess());
      },
    );
  }

  FutureOr<void> _scheduleOffer(
    CallScheduleOfferEvent event,
    Emitter<PurchasePriceState> emit,
  ) async {
    if (event.request.offerId == null && event.request.scheduleTime == null) {
      return;
    }

    emit(PurchasePriceLoading());
    final responseSchedule = await callScheduleOfferUseCase.scheduleOffer(event.request);
    if (responseSchedule.result == true) {
      final response = await getOfferDetailUseCase.call(event.request.offerId);
      response.fold(
            (l) => emit(PurchasePriceLoading()),
            (r) {
          offerModel = r;
          emit(PurchasePriceGetOfferSuccess());
        },
      );
    }
  }
}
