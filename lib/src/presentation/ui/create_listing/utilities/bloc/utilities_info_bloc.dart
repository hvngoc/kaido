import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/domain/usecase/filter/get_advantage_category_list_usecase.dart';
import 'package:propzy_home/src/domain/usecase/filter/get_amenity_category_list_usecase.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/utilities/bloc/utilities_info_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/utilities/bloc/utilities_info_state.dart';

class UtilitiesInfoBloc extends Bloc<UtilitiesInfoEvent, UtilitiesInfoState> {
  UtilitiesInfoBloc() : super(InitialUtilitiesInfoState());

  final UpdateUtilitiesListingUseCase updateUtilitiesInfoListingUseCase =
      GetIt.instance.get<UpdateUtilitiesListingUseCase>();

  final advantageUseCase = GetIt.I<GetAdvantageCategoryListUseCase>();

  final amenityUseCase = GetIt.I<GetAmenityCategoryListUseCase>();

  @override
  Stream<UtilitiesInfoState> mapEventToState(UtilitiesInfoEvent event) async* {
    if (event is UpdateUtilitiesInfoEvent) {
      yield* updateUtilitiesInfoListing(event.request);
    } else if (event is LoadListAdvantageEvent) {
      yield* getListAdvantage();
    } else if (event is LoadListAmenityEvent) {
      yield* getListAmenity();
    }
  }

  Stream<UtilitiesInfoState> updateUtilitiesInfoListing(
      UpdateUtilitiesListingRequest request) async* {
    yield LoadingState();
    try {
      BaseResponse<dynamic> response =
          await updateUtilitiesInfoListingUseCase.updateUtilities(request);
      if (response.result == true) {
        yield SuccessUpdateUtilitiesInfoState();
      } else {
        yield ErrorState(response.message);
      }
    } catch (ex) {
      yield ErrorState(ex.toString());
    }
  }

  Stream<UtilitiesInfoState> getListAdvantage() async* {
    emit(LoadingState());
    final result = await advantageUseCase.call(NoParams());
    result.fold(
      (l) => emit(ErrorState(l.message)),
      (advantageList) => emit(SuccessLoadListAdvantageState(advantageList)),
    );
  }

  Stream<UtilitiesInfoState> getListAmenity() async* {
    emit(LoadingState());
    final result = await amenityUseCase.call(NoParams());
    result.fold(
      (l) => emit(ErrorState(l.message)),
      (amenityList) => emit(SuccessLoadListAmenityState(amenityList)),
    );
  }
}
