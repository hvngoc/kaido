import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_3/bloc/Step3Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_3/bloc/Step3State.dart';

class Step3Bloc extends Bloc<Step3Event, Step3State> {
  final GetListHouseShapeUseCase shapeUseCase = GetIt.instance.get<GetListHouseShapeUseCase>();
  final GetListHouseDirectionUseCase directionUseCase =
      GetIt.instance.get<GetListHouseDirectionUseCase>();

  List<HomeDirection>? listDirection;
  List<HomeDirection>? listShape;

  Step3Bloc() : super(Step3Loading()) {
    on<Step3Event>(_getListTexture);
  }

  FutureOr<void> _getListTexture(Step3Event event, Emitter<Step3State> emit) async {
    final list = await Future.wait([directionUseCase.call(null), shapeUseCase.call(null)]);
    if (list.isNotEmpty) {
      final first = list[0].fold(
        (l) {
          emit(Step3Loading());
          return false;
        },
        (r) {
          listDirection = r;
          return true;
        },
      );
      if (first) {
        list[1].fold(
          (l) => emit(Step3Loading()),
          (r) {
            listShape = r;
            emit(Step3Success());
          },
        );
      }
    }
  }
}
