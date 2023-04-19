import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/domain/usecase/propzy_home/get_list_property_type_use_case.dart';

part 'detail_offer_event.dart';

part 'detail_offer_state.dart';

class DetailOfferBloc extends Bloc<DetailOfferEvent, DetailOfferState> {
  final getOfferDetailUseCase = GetIt.I.get<GetOfferDetailUseCase>();
  final GetListPropertyTypeUseCase getListPropertyTypeUseCase =
      GetIt.instance.get<GetListPropertyTypeUseCase>();

  HomeOfferModel? offerModel;
  List<PropzyHomePropertyType>? propertyTypes;

  DetailOfferBloc() : super(DetailOfferInitial()) {
    on<DetailOfferGetOfferEvent>(_getOfferDetail);
    on<GetPropertyTypeEvent>(_getListPropertyType);
  }

  FutureOr<void> _getOfferDetail(
    DetailOfferGetOfferEvent event,
    Emitter<DetailOfferState> emit,
  ) async {
    emit(DetailOfferInitial());
    final response = await getOfferDetailUseCase.call(event.offerId);
    response.fold(
      (l) => emit(DetailOfferGetOfferFail()),
      (r) {
        offerModel = r;
        emit(DetailOfferGetOfferSuccess());
      },
    );
  }

  FutureOr<void> _getListPropertyType(
      GetPropertyTypeEvent event, Emitter<DetailOfferState> emit) async {
    try {
      BaseResponse<List<PropzyHomePropertyType>> response =
          await getListPropertyTypeUseCase.getListPropertyType();
      if (response.result == true) {
        propertyTypes = response.data;
        emit(SuccessGetPropertyTypeState(response.data));
      } else {
        propertyTypes = null;
        emit(ErrorGetPropertyTypeState(message: response.message));
      }
    } catch (ex) {
      propertyTypes = null;
      emit(ErrorGetPropertyTypeState(message: ex.toString()));
    }
  }
}
