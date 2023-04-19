import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_marker_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/model/request_listing_in_distance_model.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';

part 'map_info_card_event.dart';
part 'map_info_card_state.dart';

class MapInfoCardBloc extends Bloc<MapInfoCardEvent, MapInfoCardState> {
  late HomeOfferModel offerModel;
  late RequestListingInDistanceModel request;
  int tag = 100;

  MapInfoCardBloc() : super(InitialMapInfoCardState());

  final GetListingInDistanceUseCase getListingInDistanceUseCase =
      GetIt.I.get<GetListingInDistanceUseCase>();

  @override
  Stream<MapInfoCardState> mapEventToState(MapInfoCardEvent event) async* {
    if (event is GetListingInDistanceEvent) {
      this.tag = event.tag;
      yield* getListingInDistance(event.tag);
    }
  }

  Stream<MapInfoCardState> getListingInDistance(int tag) async* {
    yield LoadingState();
    try {
      request = RequestListingInDistanceModel(
        propertyTypeId: offerModel.propertyType?.id,
        listingTypeId: 1,
        cityId: offerModel.cityId,
        distanceKm: tag / 1000,
        latitude: offerModel.latitude,
        longitude: offerModel.longitude,
      );

      BaseResponse<List<PropzyHomeMarkerModel>> response =
          await getListingInDistanceUseCase.getListingInDistance(request);
      if (response.result == true) {
        yield MapInfoCardGetListingInDistanceSuccessState(response.data ?? []);
      } else {
        yield MapInfoCardGetListingInDistanceErrorState(
            message: response.message);
      }
    } catch (ex) {
      yield MapInfoCardGetListingInDistanceErrorState(message: ex.toString());
    }
  }
}
