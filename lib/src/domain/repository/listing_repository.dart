import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/listing_alley.dart';
import 'package:propzy_home/src/domain/model/listing_building.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/model/listing_status_quos.dart';
import 'package:propzy_home/src/domain/request/listing_price_request.dart';
import 'package:propzy_home/src/domain/request/listing_texture_request.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/request/listing_area_direction_request.dart';
import 'package:propzy_home/src/domain/request/listing_category_request.dart';
import 'package:propzy_home/src/domain/request/listing_image_request.dart';
import 'package:propzy_home/src/domain/request/listing_legal_docs_request.dart';
import 'package:propzy_home/src/domain/request/listing_plan_to_buy.dart';
import 'package:propzy_home/src/domain/request/listing_position_request.dart';
import 'package:propzy_home/src/domain/request/listing_title_description_request.dart';

abstract class ListingRepository {
  Future<BaseResponse<Listing>> getDetailListing(int listingId);

  Future<BaseResponse<ListingInteraction>> getListingInteraction(int listingId);

  Future<BaseResponse<List<ListingAlley>>> getListAlleys();

  Future<BaseResponse<List<ListingBuilding>>> getListBuildings(int districtId);

  Future<BaseResponse<dynamic>> updateCategoryStep(
      ListingCategoryRequest request);

  Future<BaseResponse<List<SearchAddress>>> searchAddressSuggestion(
      String textSearch);

  Future<BaseResponse<AddressByLocation>> getLocationInformation(
      String location);

  Future<BaseResponse<CreateListingResponse>> createListing(
      CreateListingRequest request);

  Future<BaseResponse<dynamic>> updateAreaDirectionStep(
      ListingAreaDirectionRequest request);

  Future<BaseResponse<dynamic>> updateLegalDocsStep(
      ListingLegalDocsRequest request);

  Future<BaseResponse<dynamic>> updatePlanToBuy(ListingPlanToBuy request);

  Future<BaseResponse<List<StatusQuos>>> getListStatusQuos();

  Future<BaseResponse<List<HomeDirection>>> getListUseRightType();

  Future<BaseResponse<List<HomeDirection>>> getListPlanToBuy();

  Future<BaseResponse<dynamic>> updatePositionStep(
      ListingPositionRequest request);

  Future<BaseResponse<dynamic>> updateImageStep(ListingImageRequest request);

  Future<BaseResponse<dynamic>> updateAddressListing(
      CreateListingRequest request);

  Future<BaseResponse<dynamic>> updateMapListing(
      UpdateMapListingRequest request);

  Future<BaseResponse<dynamic>> updateOwnerInfo(
      UpdateOwnerInfoListingRequest request);

  Future<BaseResponse<dynamic>> updateUtilities(
      UpdateUtilitiesListingRequest request);

  Future<BaseResponse<DraftListing>> getDraftListingDetail(int listingId);

  Future<BaseResponse<dynamic>> updateTextureStep(
    ListingTextureRequest request,
  );

  Future<BaseResponse<dynamic>> updateTitleDescriptionStep(
    ListingTitleDescriptionRequest request,
  );

  Future<BaseResponse<dynamic>> updatePriceStep(
    ListingPriceRequest request,
  );
}
