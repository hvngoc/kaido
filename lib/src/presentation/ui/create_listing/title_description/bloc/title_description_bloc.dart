import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:propzy_home/src/domain/request/listing_title_description_request.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/util/util.dart';

part 'title_description_event.dart';

part 'title_description_state.dart';

class TitleDescriptionBloc extends Bloc<TitleDescriptionEvent, TitleDescriptionState> {
  final UpdateTitleDescriptionStepUseCase _updateUseCase =
      GetIt.instance.get<UpdateTitleDescriptionStepUseCase>();

  TitleDescriptionBloc() : super(TitleDescriptionLoading()) {
    on<UpdateTitleDescriptionStepEvent>(updateStep);
  }

  FutureOr<void> updateStep(
    UpdateTitleDescriptionStepEvent event,
    Emitter<TitleDescriptionState> emitter,
  ) async {
    Util.showLoading();
    final request = event.request;
    final results = await _updateUseCase.updateTitleDescriptionStep(request);
    Util.hideLoading();
    results.fold(
      (l) => emitter(UpdateTitleDescriptionStepFail(l.message)),
      (r) => emitter(UpdateTitleDescriptionStepSuccess()),
    );
  }
}
