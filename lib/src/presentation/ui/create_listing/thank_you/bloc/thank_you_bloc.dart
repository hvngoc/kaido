import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/category_home_listing.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/property_type_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';
import 'package:propzy_home/src/domain/usecase/get_listing_search_home.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/thank_you/bloc/thank_you_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/thank_you/bloc/thank_you_state.dart';

class ThankYouBloc extends Bloc<ThankYouEvent, ThankYouState> {
  static const int SIZE = 12;

  GetListingSearchHomeUseCase getGetListing = GetIt.instance.get<GetListingSearchHomeUseCase>();

  ThankYouBloc() : super(ThankYouInitial()) {
    on<ThankYouEvent>(_getListRecommend);
  }

  Future<FutureOr<void>> _getListRecommend(ThankYouEvent e, Emitter<ThankYouState> emit) async {
    CategorySearchRequest request = CategorySearchRequest(
        listingTypeId: CategoryType.BUY.type,
        categoryType: CategoryType.BUY,
        size: SIZE,
        page: 0,
        districtIds: [e.districtId?.id ?? 0],
        minPrice: e.priceFrom?.toDouble(),
        maxPrice: e.priceTo?.toDouble(),
        propertyTypeIds: [
          PropertyType(
            id: e.propertyTypeId?.id,
            name: e.propertyTypeId?.name,
            isChecked: true,
          ),
          PropertyType(
            id: e.propertyTypeId?.id,
            name: e.propertyTypeId?.name,
            isChecked: false,
          )
        ]);
    BaseResponse<PagingResponse<CategoryHomeListing>> response =
        await getGetListing.getListing(request);
    if (response.result == true) {
      final list = response.data?.content;
      if (list?.isNotEmpty == true) {
        emit(ThankYouSuccess(list: list));
      } else {
        emit(ThankYouLoading());
      }
    } else {
      emit(ThankYouLoading());
    }
  }
}
