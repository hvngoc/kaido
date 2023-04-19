import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/listing_alley.dart';
import 'package:propzy_home/src/domain/request/listing_position_request.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/domain/usecase/detail_listing_use_case.dart';
import 'package:propzy_home/src/util/util.dart';

part 'choose_facade_event.dart';

part 'choose_facade_state.dart';

class ChooseFacadeBloc extends Bloc<ChooseFacadeEvent, ChooseFacadeState> {
  final _getListAlleysUseCase = GetIt.instance.get<GetListAlleysUseCase>();
  final _updatePositionListingUseCase = GetIt.instance.get<UpdatePositionListingUseCase>();

  List<ListingAlley>? listAlleys;
  List<RoadFrontageDistanceType> listDistances = [
    RoadFrontageDistanceType(name: '<= 100m', min: 0, max: 100),
    RoadFrontageDistanceType(name: '100m - 200m', min: 100, max: 200),
    RoadFrontageDistanceType(name: '200m - 500m', min: 200, max: 500),
    RoadFrontageDistanceType(name: '> 500m', min: 500),
  ];

  ChooseFacadeBloc() : super(ChooseFacadeInitial()) {
    on<GetListAlleysEvent>(_getListAlleys);
    on<UpdatePositionListingEvent>(_updatePosition);
  }

  FutureOr<void> _getListAlleys(
    GetListAlleysEvent event,
    Emitter<ChooseFacadeState> emitter,
  ) async {
    final results = await _getListAlleysUseCase.call(null);
    results.fold((l) => emitter(ChooseFacadeLoading()), (r) {
      listAlleys = r;
      emitter(ChooseFacadeSuccess());
    });
  }

  FutureOr<void> _updatePosition(
    UpdatePositionListingEvent event,
    Emitter<ChooseFacadeState> emit,
  ) async {
    Util.showLoading();
    final request = event.request;
    final results = await _updatePositionListingUseCase.update(
        request.id,
        request.currentStep,
        request.positionId,
        request.roadFrontageWidth,
        request.alleyId,
        request.roadFrontageDistanceFrom,
        request.roadFrontageDistanceTo);
    Util.hideLoading();
    results.fold((l) {}, (r) {
      emit(UpdatePositionSuccess());
    });
  }
}

class RoadFrontageDistanceType extends Equatable {
  final String name;
  final double min;
  final double? max;

  RoadFrontageDistanceType({
    required this.name,
    required this.min,
    this.max,
  });

  factory RoadFrontageDistanceType.fromMinMax(double minValue, double? maxValue) {
    String nameValue = '';
    if (maxValue != null) {
      if (minValue == 0) {
        nameValue = '<= ${maxValue.toInt()}m';
      } else {
        nameValue = '${minValue.toInt()}m - ${maxValue.toInt()}m';
      }
    } else {
      nameValue = '> ${minValue.toInt()}m';
    }
    return RoadFrontageDistanceType(min: minValue, max: maxValue, name: nameValue);
  }

  @override
  List<Object?> get props => [name, min, max];
}
