import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/contact_info/bloc/owner_info_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/contact_info/bloc/owner_info_state.dart';

class OwnerInfoBloc extends Bloc<OwnerInfoEvent, OwnerInfoState> {
  OwnerInfoBloc() : super(InitialOwnerInfoState());

  final UpdateOwnerInfoListingUseCase updateOwnerInfoListingUseCase =
      GetIt.instance.get<UpdateOwnerInfoListingUseCase>();

  @override
  Stream<OwnerInfoState> mapEventToState(OwnerInfoEvent event) async* {
    if (event is UpdateOwnerInfoEvent) {
      yield* updateOwnerInfoListing(event.request);
    }
  }

  Stream<OwnerInfoState> updateOwnerInfoListing(UpdateOwnerInfoListingRequest request) async* {
    yield LoadingState();
    try {
      BaseResponse<dynamic> response = await updateOwnerInfoListingUseCase.updateOwnerInfo(request);
      if (response.result == true) {
        yield SuccessUpdateOwnerInfoState();
      } else {
        yield ErrorState(response.message);
      }
    } catch (ex) {
      yield ErrorState(ex.toString());
    }
  }
}
