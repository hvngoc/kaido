import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/local/pref/app_pref.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';
import 'package:propzy_home/src/domain/usecase/get_listing_search_home.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_event.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_state.dart';
import 'package:propzy_home/src/presentation/ui/search/result/sort_by_home.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';

import '../../../../../domain/usecase/search_use_case.dart';

abstract class BaseResultBloc<T> extends Bloc<CategoryEvent, CategoryResultState> {
  static final int SIZE = 10;

  abstract BaseGetListingSearchUseCase<T> getGetListingSearchHomeUseCase;
  final PrefHelper prefHelper = GetIt.instance.get<PrefHelper>();
  final GetSearchHistoryUseCase getSearchHistoryUseCase = GetIt.instance.get<GetSearchHistoryUseCase>();

  int page = 0;
  SortBy sortBy = SortBy.DEFAULT;

  CategorySearchRequest categoryRequest = CategorySearchRequest(
    listingTypeId: CategoryType.BUY.type,
    categoryType: CategoryType.BUY,
  );
  List<SearchHistory> locationTags = [];

  List<T>? listData;
  bool isLastPage = false;

  BaseResultBloc() : super(LoadingState());

  @override
  Stream<CategoryResultState> mapEventToState(CategoryEvent event) async* {
    if (event is GetListHomeEvent) {
      page = 0;
      yield* getListHome(false);
    } else if (event is GetListHomeLoadMoreEvent) {
      page++;
      yield* getListHome(true);
    } else if (event is ChangeSortByEvent) {
      page = 0;
      sortBy = event.sortBy;
      yield* getListHome(false);
    } else if (event is UpdateLocationTag) {
      locationTags = event.location;
      page = 0;
      yield* getListHome(false);
    } else if (event is UpdateFilter) {
      locationTags = event.address;
      categoryRequest = event.request;
      page = 0;
      yield* getListHome(false);
    } else if (event is GetLastSearchEvent) {
      yield* getLastSearch();
    } else if (event is ResetFilterEvent) {
      categoryRequest = categoryRequest.resetFilter();
      yield* getListHome(false);
    } else if (event is ResetPropertyTypeEvent) {
      categoryRequest.propertyTypeIds = null;
      yield* getListHome(false);
    } else if (event is ResetAmenityEvent || event is ResetAdvantageEvent) {
      categoryRequest.advantageIds = null;
      categoryRequest.amenityIds = null;
      yield* getListHome(false);
    } else if (event is ResetDirectionEvent) {
      categoryRequest.directionIds = null;
      yield* getListHome(false);
    } else if (event is ResetStatusEvent) {
      categoryRequest.statusIds = categoryRequest.categoryType.type == CategoryType.PROJECT.type
          ? null
          : [Constants.CATEGORY_FILTER_STATUS_LIVE];
      yield* getListHome(false);
    } else if (event is ResetBedroomsEvent) {
      categoryRequest.bedrooms = null;
      yield* getListHome(false);
    } else if (event is ResetBathroomsEvent) {
      categoryRequest.bathrooms = null;
      yield* getListHome(false);
    } else if (event is ResetContentEvent) {
      categoryRequest.contentId = null;
      yield* getListHome(false);
    } else if (event is ResetPropertyPositionEvent) {
      categoryRequest.propertyPosition = null;
      yield* getListHome(false);
    } else if (event is ResetYearEvent) {
      categoryRequest.minYear = null;
      categoryRequest.maxYear = null;
      yield* getListHome(false);
    } else if (event is ResetPriceEvent) {
      categoryRequest.minPrice = null;
      categoryRequest.maxPrice = null;
      yield* getListHome(false);
    } else if (event is ResetSizeEvent) {
      categoryRequest.minSize = null;
      categoryRequest.maxSize = null;
      yield* getListHome(false);
    } else {
      super.onEvent(event);
    }
  }

  Stream<CategoryResultState> getLastSearch() async* {

    late SearchHistory searchItemView;

    try {
      final accessToken = await prefHelper.getAccessToken();
      if(accessToken?.isNotEmpty == true){
        final response = await getSearchHistoryUseCase.getSearchHistory();
        if(response.data?.isNotEmpty == true){
          searchItemView = response.data![0];
          yield GetLastSearchSuccess(searchItemView);
          return;
        }
      }
      var jsonString = await prefHelper.getString(AppPrefs.lastSearchHistoryKey) ?? "";
      if (jsonString.isNotEmpty) {
        searchItemView = SearchHistory.fromJson(json.decode(jsonString.toString()));
      } else {
        searchItemView = SearchHistory.getDefaultSearch();
      }
      yield GetLastSearchSuccess(searchItemView);
    } catch (e) {
      Log.e(e.toString());
      yield GetLastSearchSuccess(SearchHistory.getDefaultSearch());
    }
  }

  Stream<CategoryResultState> getListHome(bool loadingMore) async* {
    try {
      CategorySearchRequest request = _generateRequest();
      categoryRequest = request;

      BaseResponse<PagingResponse<T>> response =
          await getGetListingSearchHomeUseCase.getListing(request);
      if (response.result == true) {
        isLastPage = response.data?.last ?? false;
        if (response.data?.empty == true) {
          yield EmptyState();
        } else {
          if (loadingMore) {
            listData?.addAll(response.data?.content ?? []);
            response.data?.content = listData;
          }
          listData = response.data?.content;
          yield SuccessState(response.data);
        }
      } else {
        yield ErrorState(response.message);
      }
    } catch (e) {
      Log.e("search-result: " + e.toString());
      yield ErrorState(e.toString());
    }
  }

  CategorySearchRequest _generateRequest() {
    double? lat;
    double? lng;

    List<int> cityIds = [];
    List<int> districtIds = [];
    List<int> wardIds = [];
    List<int> streetIds = [];

    locationTags.forEach((item) {
      if (item.isUseMyLocation == true) {
        lat = item.lat;
        lng = item.lng;
      } else {
        if (item.resultType == SearchResultType.CITY.type) {
          int? id = item.metaData?.cityId;
          if (id != null) {
            cityIds.add(id);
          }
        } else if (item.resultType == SearchResultType.DISTRICT.type) {
          int? id = item.metaData?.districtId;
          if (id != null) {
            districtIds.add(id);
          }
        } else if (item.resultType == SearchResultType.WARD.type) {
          int? id = item.metaData?.wardId;
          if (id != null) {
            wardIds.add(id);
          }
        } else if (item.resultType == SearchResultType.STREET.type) {
          int? id = item.metaData?.streetId;
          if (id != null) {
            streetIds.add(id);
          }
        }
      }
    });

    CategorySearchRequest res = categoryRequest.copyWith(
      size: SIZE,
      page: page,
    )
      ..sortBy = sortBy.sortBy
      ..sortDirection = sortBy.sortDirection
      ..lat = lat
      ..lng = lng
      ..cityIds = cityIds
      ..districtIds = districtIds
      ..wardIds = wardIds
      ..streetIds = streetIds;

    return res;
  }
}
