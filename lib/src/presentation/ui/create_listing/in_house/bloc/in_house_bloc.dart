import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/in_house/bloc/in_house_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/in_house/bloc/in_house_state.dart';
import 'package:propzy_home/src/util/util.dart';

class InHouseBloc extends Bloc<InHouseEvent, BaseInHouseState> {
  final GetListHouseDirectionUseCase directionUseCase =
      GetIt.instance.get<GetListHouseDirectionUseCase>();
  final UpdateAreaDirectionListingUseCase updateUseCase =
      GetIt.instance.get<UpdateAreaDirectionListingUseCase>();

  List<HomeDirection>? listDirections;
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

  InHouseBloc() : super(InHouseStateInitial()) {
    on<LoadDirectionEvent>(_getListDirection);
    on<UpdateInHouseEvent>(_updateRequest);
  }

  Future<FutureOr<void>> _getListDirection(
      InHouseEvent event, Emitter<BaseInHouseState> emit) async {
    final direction = await directionUseCase.call(null);
    direction.fold(
      (l) {},
      (r) async {
        listDirections = r;
      },
    );
    emit(InHouseStateInitial());
  }

  Future<FutureOr<void>> _updateRequest(
      UpdateInHouseEvent e, Emitter<BaseInHouseState> emit) async {
    Util.showLoading();
    final result = await updateUseCase.update(
      e.id,
      e.bathrooms,
      e.bedrooms,
      e.directionId,
      e.floorSize,
      e.lotSize,
      e.sizeLength,
      e.sizeWidth,
    );
    Util.hideLoading();
    result.fold(
      (l) => emit(InHouseStateLoading()),
      (r) {
        emit(InHouseStateSuccess());
      },
    );
  }
}
