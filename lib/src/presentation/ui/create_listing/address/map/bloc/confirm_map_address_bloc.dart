import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/map/bloc/confirm_map_address_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/map/bloc/confirm_map_address_state.dart';

class ConfirmMapAddressBloc extends Bloc<ConfirmMapAddressEvent, ConfirmMapAddressState> {
  ConfirmMapAddressBloc() : super(InitialConfirmMapAddressState());

  final UpdateAddressListingUseCase updateAddressListingUseCase =
      GetIt.instance.get<UpdateAddressListingUseCase>();

  @override
  Stream<ConfirmMapAddressState> mapEventToState(ConfirmMapAddressEvent event) async* {
    if (event is UpdateMapListingEvent) {
      yield* updateMapListing(event.request);
    }
  }

  Stream<ConfirmMapAddressState> updateMapListing(UpdateMapListingRequest request) async* {
    yield LoadingState();
    try {
      BaseResponse<dynamic> response = await updateAddressListingUseCase.updateMapListing(request);
      if (response.result == true) {
        yield SuccessUpdateMapState();
      } else {
        yield ErrorState(response.message);
      }
    } catch (ex) {
      yield ErrorState(ex.toString());
    }
  }
}
