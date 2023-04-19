import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_7/bloc/Step7Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_7/bloc/Step7State.dart';

class Step7Bloc extends Bloc<Step7Event, Step7State> {
  final GetListExpectedTimeUseCase useCase = GetIt.instance.get<GetListExpectedTimeUseCase>();

  List<HomeDirection>? listData = null;

  Step7Bloc() : super(Step7Loading()) {
    on<Step7Event>(_getListTime);
  }

  FutureOr<void> _getListTime(Step7Event event, Emitter<Step7State> emit) async {
    final direction = await useCase.call(null);
    direction.fold(
      (l) => emit(Step7Loading()),
      (r) async {
        listData = r;
        emit(Step7Success());
      },
    );
  }
}
