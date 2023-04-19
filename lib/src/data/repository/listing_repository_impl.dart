import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/remote/api/listing_service.dart';
import 'package:propzy_home/src/domain/model/listing_alley.dart';
import 'package:propzy_home/src/domain/model/listing_building.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/model/listing_status_quos.dart';
import 'package:propzy_home/src/domain/request/listing_price_request.dart';
import 'package:propzy_home/src/domain/request/listing_texture_request.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/repository/listing_repository.dart';
import 'package:propzy_home/src/domain/request/listing_area_direction_request.dart';
import 'package:propzy_home/src/domain/request/listing_category_request.dart';
import 'package:propzy_home/src/domain/request/listing_image_request.dart';
import 'package:propzy_home/src/domain/request/listing_legal_docs_request.dart';
import 'package:propzy_home/src/domain/request/listing_plan_to_buy.dart';
import 'package:propzy_home/src/domain/request/listing_position_request.dart';
import 'package:propzy_home/src/domain/request/listing_title_description_request.dart';

class ListingRepositoryImpl extends ListingRepository {
  late final ListingService service;

  ListingRepositoryImpl(this.service);

  @override
  Future<BaseResponse<Listing>> getDetailListing(int listingId) {
    return service.getDetailListing(listingId);
  }

  @override
  Future<BaseResponse<ListingInteraction>> getListingInteraction(
      int listingId) {
    return service.getListingInteraction(listingId);
  }

  @override
  Future<BaseResponse<List<ListingAlley>>> getListAlleys() {
    return service.getListAlleys();
  }

  @override
  Future<BaseResponse<List<ListingBuilding>>> getListBuildings(int districtId) {
    return service.getListBuildings(districtId);
  }

  @override
  Future<BaseResponse> updateCategoryStep(ListingCategoryRequest request) {
    return service.updateCategoryStep(request);
  }

  @override
  Future<BaseResponse<List<SearchAddress>>> searchAddressSuggestion(
      String textSearch) {
    return service.searchAddressSuggestion(textSearch);
  }

  @override
  Future<BaseResponse<AddressByLocation>> getLocationInformation(
      String location) {
    return service.getLocationInformation(location);
  }

  @override
  Future<BaseResponse<CreateListingResponse>> createListing(
      CreateListingRequest request) {
    return service.createListing(request);
  }

  @override
  Future<BaseResponse> updateAreaDirectionStep(
      ListingAreaDirectionRequest request) {
    return service.updateAreaDirectionStep(request);
  }

  @override
  Future<BaseResponse> updateLegalDocsStep(ListingLegalDocsRequest request) {
    return service.updateLegalDocsStep(request);
  }

  @override
  Future<BaseResponse> updatePlanToBuy(ListingPlanToBuy request) {
    return service.updatePlanToBuy(request);
  }

  @override
  Future<BaseResponse<List<StatusQuos>>> getListStatusQuos() {
    return service.getListStatusQuos();
  }

  @override
  Future<BaseResponse<List<HomeDirection>>> getListUseRightType() {
    return service.getListUseRightType();
  }

  @override
  Future<BaseResponse<List<HomeDirection>>> getListPlanToBuy() {
    return service.getListPlanToBuy();
  }

  @override
  Future<BaseResponse<dynamic>> updatePositionStep(
      ListingPositionRequest request) {
    return service.updatePositionStep(request);
  }

  @override
  Future<BaseResponse<dynamic>> updateImageStep(ListingImageRequest request) {
    return service.updateImageStep(request);
  }

  @override
  Future<BaseResponse> updateAddressListing(CreateListingRequest request) {
    return service.updateAddressListing(request);
  }

  @override
  Future<BaseResponse> updateMapListing(UpdateMapListingRequest request) {
    return service.updateMapListing(request);
  }

  @override
  Future<BaseResponse> updateOwnerInfo(UpdateOwnerInfoListingRequest request) {
    return service.updateOwnerInfo(request);
  }

  @override
  Future<BaseResponse> updateUtilities(UpdateUtilitiesListingRequest request) {
    return service.updateUtilities(request);
  }

  @override
  Future<BaseResponse<DraftListing>> getDraftListingDetail(int listingId) {
    return service.getDraftListingDetail(listingId);
  }

  @override
  Future<BaseResponse<dynamic>> updateTextureStep(
    ListingTextureRequest request,
  ) {
    return service.updateTextureStep(
      request,
    );
  }

  @override
  Future<BaseResponse<dynamic>> updateTitleDescriptionStep(
    ListingTitleDescriptionRequest request,
  ) {
    return service.updateTitleDescriptionStep(request);
  }

  @override
  Future<BaseResponse<dynamic>> updatePriceStep(
    ListingPriceRequest request,
  ) {
    return service.updatePriceStep(
      request,
    );
  }
}
