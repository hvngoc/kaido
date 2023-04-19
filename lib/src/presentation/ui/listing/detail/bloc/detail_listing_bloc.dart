import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/config/app_config.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/usecase/detail_listing_use_case.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/bloc/detail_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/bloc/detail_listing_state.dart';

class DetailListingBloc extends Bloc<DetailListingEvent, DetailListingState> {
  DetailListingBloc() : super(InitializeDetailListingState());

  final GetDetailListingUseCase getDetailListingUseCase =
      GetIt.instance.get<GetDetailListingUseCase>();
  final GetListingInteractionUseCase getListingInteractionUseCase =
      GetIt.instance.get<GetListingInteractionUseCase>();

  final AppConfig _appConfig = GetIt.instance.get<AppConfig>();

  @override
  Stream<DetailListingState> mapEventToState(DetailListingEvent event) async* {
    if (event is GetListingDetailEvent) {
      yield* getDetailListing(event.listingId);
    } else if (event is GetListingInteractionEvent) {
      yield* getListingInteraction(event.listingId);
    }
  }

  Stream<DetailListingState> getDetailListing(int listingId) async* {
    yield LoadingState();
    try {
      BaseResponse<Listing> response = await getDetailListingUseCase.getDetailListing(listingId);
      if (response.result == true) {
        yield SuccessGetDetailListingState(response.data);
      } else {
        yield ErrorGetDetailListingState();
      }
    } catch (ex) {
      yield ErrorState(message: ex.toString());
    }
  }

  Stream<DetailListingState> getListingInteraction(int listingId) async* {
    try {
      BaseResponse<ListingInteraction> response =
          await getListingInteractionUseCase.getListingInteraction(listingId);
      if (response.result == true) {
        yield SuccessGetListingInteractionState(response.data);
      } else {
        yield ErrorState();
      }
    } catch (ex) {
      yield ErrorState(message: ex.toString());
    }
  }

  Future<void> share(String? url) async {
    await FlutterShare.share(linkUrl: _appConfig.portalURL + url!, title: _appConfig.portalURL);
  }
}
