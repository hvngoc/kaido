import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_1/bloc/Apartment1Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_1/bloc/Apartment1State.dart';

class Apartment1Bloc extends Bloc<Apartment1Event, Apartment1State> {
  final GetListHouseDirectionUseCase directionUseCase =
      GetIt.instance.get<GetListHouseDirectionUseCase>();

  List<HomeDirection>? listDirections;

  Apartment1Bloc() : super(Apartment1Loading()) {
    on<Apartment1Event>(_getListTexture);
  }

  FutureOr<void> _getListTexture(Apartment1Event event, Emitter<Apartment1State> emit) async {
    final direction = await directionUseCase.call(null);
    direction.fold(
      (l) => emit(Apartment1Loading()),
      (r) async {
        listDirections = r;
        emit(Apartment1Success());
      },
    );
  }
}
