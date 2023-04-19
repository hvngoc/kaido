import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_9/bloc/Step9Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_9/bloc/Step9State.dart';

class Step9Bloc extends Bloc<Step9Event, Step9State> {
  final GetListPlanToBuyUseCase useCase = GetIt.instance.get<GetListPlanToBuyUseCase>();

  List<HomeDirection>? listData = null;

  Step9Bloc() : super(Step9Loading()) {
    on<Step9Event>(_getListTime);
  }

  FutureOr<void> _getListTime(Step9Event event, Emitter<Step9State> emit) async {
    final direction = await useCase.call(null);
    direction.fold(
      (l) => emit(Step9Loading()),
      (r) async {
        listData = r;
        emit(Step9Success());
      },
    );
  }
}
