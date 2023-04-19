import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/listing_building.dart';
import 'package:propzy_home/src/domain/usecase/detail_listing_use_case.dart';

part 'choose_building_event.dart';

part 'choose_building_state.dart';

class ChooseBuildingBloc extends Bloc<ChooseBuildingEvent, ChooseBuildingState> {
  final _getListBuildingsUseCase = GetIt.instance.get<GetListBuildingsUseCase>();

  List<ListingBuilding> listBuildings = [];

  ChooseBuildingBloc() : super(ChooseBuildingLoading()) {
    on<SearchNameEvent>(_searchText);
    on<LoadDataEvent>(_getListBuildings);
  }

  FutureOr<void> _searchText(
    SearchNameEvent event,
    Emitter<ChooseBuildingState> emitter,
  ) async {
    final name = event.name ?? '';
    if (listBuildings.isEmpty) {
      emitter(ChooseBuildingEmpty());
    } else if (name.isEmpty) {
      emitter(ChooseBuildingSuccess(listBuildings));
    } else {
      List<ListingBuilding> res = listBuildings
          .where((e) =>
              (e.name?.toLowerCase().contains(name.toLowerCase()) ?? false) ||
              e.unsignedName.toLowerCase().contains(name.toLowerCase()))
          .toList();
      if (res.isEmpty) {
        emitter(ChooseBuildingEmpty());
      } else {
        emitter(ChooseBuildingSuccess(res));
      }
    }
  }

  FutureOr<void> _getListBuildings(
    LoadDataEvent event,
    Emitter<ChooseBuildingState> emitter,
  ) async {
    final result = await _getListBuildingsUseCase.call(event.districtId);
    result.fold((l) {}, (r) {
      listBuildings = r ?? [];
      emitter(ChooseBuildingSuccess(listBuildings));
    });
  }
}
