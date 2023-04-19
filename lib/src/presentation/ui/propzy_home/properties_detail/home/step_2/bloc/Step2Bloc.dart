import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_contiguous.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_2/bloc/Step2Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_2/bloc/Step2State.dart';

class Step2Bloc extends Bloc<Step2Event, Step2State> {
  final GetListContiguousUseCase useCase = GetIt.instance.get<GetListContiguousUseCase>();

  List<HomeContiguous>? listAlley;
  List<HomeContiguous>? listRoad;

  Step2Bloc() : super(Step2Loading()) {
    on<Step2Event>(_getListTexture);
  }

  FutureOr<void> _getListTexture(Step2Event event, Emitter<Step2State> emit) async {
    final list = await Future.wait([useCase.call(1), useCase.call(2)]);
    if (list.isNotEmpty) {
      final ok = list[0].fold(
        (l) {
          emit(Step2Loading());
          return false;
        },
        (r) {
          listRoad = r;
          return true;
        },
      );
      if (ok) {
        list[1].fold(
          (l) => emit(Step2Loading()),
          (r) {
            listAlley = r;
            emit(Step2Success());
          },
        );
      }
    }
  }
}
