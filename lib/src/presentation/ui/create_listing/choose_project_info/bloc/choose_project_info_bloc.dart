import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:propzy_home/src/domain/model/listing_building.dart';
import 'package:propzy_home/src/domain/request/listing_position_request.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/domain/usecase/detail_listing_use_case.dart';
import 'package:propzy_home/src/util/util.dart';

part 'choose_project_info_event.dart';

part 'choose_project_info_state.dart';

class ChooseProjectInfoBloc extends Bloc<ChooseProjectInfoEvent, ChooseProjectInfoState> {
  final _getListBuildingsUseCase = GetIt.instance.get<GetListBuildingsUseCase>();
  final _updateUseCase = GetIt.instance.get<UpdateProjectInfoListingUseCase>();

  ChooseProjectInfoBloc() : super(ChooseProjectInfoInitial()) {
    on<GetListBuildingsEvent>(_getListBuildings);
    on<UpdateProjectInfoListingEvent>(_updateProjectInfo);
  }

  List<ListingBuilding>? listBuildings;

  FutureOr<void> _getListBuildings(
    GetListBuildingsEvent event,
    Emitter<ChooseProjectInfoState> emitter,
  ) async {
    final result = await _getListBuildingsUseCase.call(event.districtId);
    result.fold((l) {}, (r) {
      listBuildings = r;
      emitter(GetListBuildingsSuccess());
    });
  }

  FutureOr<void> _updateProjectInfo(
    UpdateProjectInfoListingEvent event,
    Emitter<ChooseProjectInfoState> emitter,
  ) async {
    Util.showLoading();
    final request = event.request;
    final result = await _updateUseCase.update(request.id, request.currentStep, request.buildingId,
        request.buildingName, request.floor, request.modelCode, request.isHideModelCode);
    Util.hideLoading();
    result.fold((l) {}, (r) {
      emitter(UpdateProjectInfoSuccess());
    });
  }
}
