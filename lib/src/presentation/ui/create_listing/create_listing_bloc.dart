import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';

class CreateListingBloc
    extends Bloc<BaseCreateListingEvent, BaseCreateListingState> {
  CreateListingRequest? createListingRequest = null;

  final CreateListingUseCase createListingUseCase =
      GetIt.instance.get<CreateListingUseCase>();
  final GetDraftListingDetailUseCase getDraftListingDetailUseCase =
      GetIt.instance.get<GetDraftListingDetailUseCase>();

  DraftListing? draftListing = null;

  CreateListingBloc() : super(ListingInitialState()) {
    on<UpdateListingEvent>(_updateListingEvent);
    on<CreateListingEvent>(_createListingEvent);
    on<GetDraftListingDetailEvent>(_getDraftListingDetail);
  }

  FutureOr<void> _updateListingEvent(
    UpdateListingEvent event,
    Emitter<BaseCreateListingState> emit,
  ) {}

  FutureOr<void> _createListingEvent(
    CreateListingEvent event,
    Emitter<BaseCreateListingState> emit,
  ) async {
    emit(ListingLoadingState());
    try {
      BaseResponse<CreateListingResponse> response =
          await createListingUseCase.createListing(createListingRequest!);
      if (response.result == true) {
        createListingRequest?.id = response.data?.id;
        emit(CreateListingSuccessState());
      } else {
        emit(ErrorMessageState(response.message));
      }
    } catch (ex) {
      emit(ErrorMessageState(ex.toString()));
    }
  }

  bool isHouse(int propertiesType) {
    final houses = [9, 11, 3, 2];
    return houses.contains(propertiesType);
  }

  bool isLand(int propertiesType) {
    final lands = [13, 14, 24, 37, 39];
    return lands.contains(propertiesType);
  }

  bool isRentGroundOrAgriculturalLand(int propertyTypeId) {
    final lands = [37, 39];
    return lands.contains(propertyTypeId);
  }

  bool isPrivateHouseOrVillaDraft() {
    final propertyTypeId = draftListing?.propertyType?.id ?? 0;
    return isHouse(propertyTypeId);
  }

  FutureOr<void> _getDraftListingDetail(
    GetDraftListingDetailEvent event,
    Emitter<BaseCreateListingState> emit,
  ) async {
    emit(ListingLoadingState());
    try {
      BaseResponse<DraftListing> response = await getDraftListingDetailUseCase
          .getDraftListingDetail(event.listingId);
      if (response.result == true) {
        createListingRequest?.id = response.data?.id;
        draftListing = response.data;
        emit(GetDraftListingDetailSuccessState());
      } else {
        emit(ErrorMessageState(response.message));
      }
    } catch (ex) {
      emit(ErrorMessageState(ex.toString()));
    }
  }
}
