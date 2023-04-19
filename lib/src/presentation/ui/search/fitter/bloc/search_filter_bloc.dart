import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:propzy_home/src/data/local/pref/app_pref.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/model/common_model.dart';
import 'package:propzy_home/src/domain/model/common_model_1.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/property_type_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/domain/request/category_search_request.dart';
import 'package:propzy_home/src/domain/usecase/get_listing_search_home.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/advantage/advantage.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bathroom/bathroom.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_event.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_state.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/content/content.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/direction/direction.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/position/position.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/property/bloc/property_bloc.dart';
import 'package:propzy_home/src/util/debounce_timer.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../util/constants.dart';
import '../amenity/amenity.dart';
import '../bedroom/bedroom.dart';
import 'dart:async';



class SearchFilterBloc extends Bloc<SearchFilterEvent, SearchFilterState> {
  CategorySearchRequest categorySearchRequest;
  SearchFilterBloc(this.categorySearchRequest) : super(InitDataState()) {
  }
  final searchUseCase = GetIt.instance.get<GetListingSearchHomeUseCase>();
  final searchProjectUseCase = GetIt.instance.get<GetCategoryProjectSearchHomeUseCase>();
  final PrefHelper prefHelper = GetIt.instance.get<PrefHelper>();
  PropertyBloc? propertyBloc;
  ContentBloc? contentBloc;
  AdvantageBloc? advantageBloc;
  BathroomBloc? bathroomBloc;
  BedroomBloc? bedroomBloc;
  PositionBloc? positionBloc;
  DirectionBloc? directionBloc;
  AmenityBloc? amenityBloc;


  Future<void> search({
    isSearchProject = false,
    int? listingTypeId,
    List<PropertyType?>? propertyTypeListSelected,
    List<Direction?>? directionListSelected,
    List<Advantage?>? advantageListSelected,
    List<Amenity?>? amenityListSelected,
    double? minPrice,
    double? maxPrice,
    double? minSize,
    double? maxSize,
    int? minYear,
    int? maxYear,
    BedRoom? bedrooms,
    BathRoom? bathrooms,
    Position? propertyPosition,
    Content? contentId,
    List<int>? statusIds,
  }) async {
    // Call search
    categorySearchRequest = buildSearchRequest(
      listingTypeId: listingTypeId,
      propertyTypeListSelected: propertyTypeListSelected,
      directionListSelected: directionListSelected,
      advantageListSelected: advantageListSelected,
      amenityListSelected: amenityListSelected,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minSize: minSize,
      maxSize: maxSize,
      minYear: minYear,
      maxYear: maxYear,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      propertyPosition: propertyPosition,
      contentId: contentId,
      statusIds: statusIds,
      cityIds: categorySearchRequest.cityIds,
      districtIds: categorySearchRequest.districtIds,
      wardIds: categorySearchRequest.wardIds,
      streetIds: categorySearchRequest.streetIds,
      lat: categorySearchRequest.lat,
      lng: categorySearchRequest.lng,
    );
    final result = isSearchProject ?  await searchProjectUseCase.getListing(categorySearchRequest) :  await searchUseCase.getListing(categorySearchRequest);
    Logger().d('data totalElements: ${result.data?.totalElements}');
    emit(InitDataState(data: result.data));
  }

  Future<void> searchAddress({
    List<SearchHistory>? listSearchSelected,
  }) async {
    // Call search

    CategorySearchRequest req = _generateRequestWithLocation(listSearchSelected);

    categorySearchRequest = buildSearchRequest(
      cityIds: req.cityIds,
      districtIds: req.districtIds,
      wardIds: req.wardIds,
      streetIds: req.streetIds,
      lat: req.lat,
      lng: req.lng,
    );

    final result = await searchUseCase.getListing(categorySearchRequest);

    Logger().d('totalElements: ${result.data?.totalElements}');
    emit(InitDataState(data: result.data));
  }

  Future<void> searchAddressProject({
    List<SearchHistory>? listSearchSelected,
  }) async {

    CategorySearchRequest req = _generateRequestWithLocation(listSearchSelected);
    // Call search
    categorySearchRequest = buildSearchRequest(
      cityIds: req.cityIds,
      districtIds: req.districtIds,
      wardIds: req.wardIds,
      streetIds: req.streetIds,
      lat: req.lat,
      lng: req.lng,
    );

    final result = await searchProjectUseCase.getListing(categorySearchRequest);

    Logger().d('totalElements: ${result.data?.totalElements}');
    emit(InitDataState(data: result.data));
  }

  CategorySearchRequest buildSearchRequest({
    int? listingTypeId,
    List<PropertyType?>? propertyTypeListSelected,
    List<Direction?>? directionListSelected,
    List<Advantage?>? advantageListSelected,
    List<Amenity?>? amenityListSelected,
    double? minPrice,
    double? maxPrice,
    double? minSize,
    double? maxSize,
    int? minYear,
    int? maxYear,
    BedRoom? bedrooms,
    BathRoom? bathrooms,
    Position? propertyPosition,
    Content? contentId,
    List<int>? statusIds,
    List<int>? cityIds,
    List<int>? districtIds,
    List<int>? wardIds,
    List<int>? streetIds,
    double? lat,
    double? lng,
  }) {
    return categorySearchRequest.copyWith(
      listingTypeId: listingTypeId,
      propertyTypeIds: propertyTypeListSelected,
      directionIds: directionListSelected,
      advantageIds: advantageListSelected,
      amenityIds: amenityListSelected,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minSize: minSize,
      maxSize: maxSize,
      minYear: minYear,
      maxYear: maxYear,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      propertyPosition: propertyPosition,
      contentId: contentId,
      statusIds: statusIds,
      cityIds: cityIds,
      districtIds: districtIds,
      wardIds: wardIds,
      streetIds: streetIds,
      lat: lat,
      lng: lng,
    );
  }

  CategorySearchRequest _generateRequestWithLocation(List<SearchHistory>? listSearchSelected) {
    double? lat;
    double? lng;

    List<int> cityIds = [];
    List<int> districtIds = [];
    List<int> wardIds = [];
    List<int> streetIds = [];

    listSearchSelected?.forEach((item) {
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

    CategorySearchRequest req = categorySearchRequest.copyWith()
      ..lat = lat
      ..lng = lng
      ..cityIds = cityIds
      ..districtIds = districtIds
      ..wardIds = wardIds
      ..streetIds = streetIds;

    return req;
  }

  void saveCategoryType(CategoryType categoryType) async {
    await prefHelper.setInt(AppPrefs.lastCategoryTypeKey, categoryType.type);
  }


  FutureOr<void> resetFilterSearch() async {
    propertyBloc?.add(ResetAllPropertyEvent());
    contentBloc?.add(ResetContent());
    bedroomBloc?.add(ResetFilterBedRoomEvent());
    positionBloc?.add(ResetAllPositionEvent());
    directionBloc?.add(ResetAllDirectionEvent());
    advantageBloc?.add(ResetAdvantageEvent());
    bathroomBloc?.add(ResetFilterBathRoomEvent());
    amenityBloc?.add(ResetFilterAmenityEvent());
    categorySearchRequest.statusIds = null;
  }

  bool isCheckedRadiobutton() {
  final statusId = categorySearchRequest.statusIds;
  final id = statusId?.first;
  return id == Constants.CATEGORY_FILTER_STATUS_SOLD_OR_RENT ? true : false;
  }
}
