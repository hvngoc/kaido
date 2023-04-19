import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/request/listing_texture_request.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';

part 'create_listing_texture_event.dart';
part 'create_listing_texture_state.dart';

class CreateListingTextureBloc
    extends Bloc<CreateListingTextureEvent, CreateListingTextureState> {
  CreateListingTextureBloc() : super(CreateListingTextureInitial()) {
    on<CreateListingTextureEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<UpdateTextureEvent>(_updateListingTexture);
  }

  final UpdateTextureStepUseCase _updateTextureStepUseCase =
      GetIt.I.get<UpdateTextureStepUseCase>();

  FutureOr<void> _updateListingTexture(
    UpdateTextureEvent event,
    Emitter<CreateListingTextureState> emit,
  ) async {
    emit(LoadingState());
    ListingTextureRequest _request = event.request;
    try {
      BaseResponse response =
          await _updateTextureStepUseCase.updateTextureStep(_request);
      if (response.isSuccess()) {
        emit(SuccessState());
      } else {
        emit(ErrorState(errorMessage: response.message));
      }
    } catch (ex) {
      emit(ErrorState(errorMessage: ex.toString()));
    }
  }
}
