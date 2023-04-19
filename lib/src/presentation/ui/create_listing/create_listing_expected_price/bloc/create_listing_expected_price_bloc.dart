import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/request/listing_price_request.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';

part 'create_listing_expected_price_event.dart';
part 'create_listing_expected_price_state.dart';

class CreateListingExpectedPriceBloc extends Bloc<
    CreateListingExpectedPriceEvent, CreateListingExpectedPriceState> {
  CreateListingExpectedPriceBloc()
      : super(CreateListingExpectedPriceInitial()) {
    on<CreateListingExpectedPriceEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<UpdateListingPriceEvent>(_updateListingPrice);
  }

  final UpdatePriceStepUseCase _useCase = GetIt.I.get<UpdatePriceStepUseCase>();

  FutureOr<void> _updateListingPrice(
    UpdateListingPriceEvent event,
    Emitter<CreateListingExpectedPriceState> emit,
  ) async {
    emit(LoadingState());
    ListingPriceRequest _request = event.request;
    try {
      BaseResponse response = await _useCase.updatePriceStep(_request);
      if (response.isSuccess()) {
        emit(SuccessState());
      } else {
        emit(ErrorState(errorMessage: response.message));
      }
    } catch (ex) {
      emit(ErrorState(errorMessage: ex.toString()));
    }
  }
}
