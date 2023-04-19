import 'package:dio/dio.dart';
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
import 'package:propzy_home/src/domain/request/listing_legal_docs_request.dart';
import 'package:propzy_home/src/domain/request/listing_image_request.dart';
import 'package:propzy_home/src/domain/request/listing_plan_to_buy.dart';
import 'package:propzy_home/src/domain/request/listing_position_request.dart';
import 'package:propzy_home/src/domain/request/listing_title_description_request.dart';
import 'package:retrofit/retrofit.dart';

part 'listing_service.g.dart';

@RestApi()
abstract class ListingService {
  factory ListingService(Dio dio) = _ListingService;

  @GET("frontoffice/api/listings/{listingId}")
  Future<BaseResponse<Listing>> getDetailListing(
      @Path("listingId") int listingId);

  @GET("frontoffice/api/listings/{listingId}/interactions")
  Future<BaseResponse<ListingInteraction>> getListingInteraction(
      @Path("listingId") int listingId);

  @GET("frontoffice/api/alleys")
  Future<BaseResponse<List<ListingAlley>>> getListAlleys();

  @GET("frontoffice/api/buildings")
  Future<BaseResponse<List<ListingBuilding>>> getListBuildings(
      @Query("districtId") int districtId);

  @PUT("frontoffice/api/lso-listing-drafts/describe-step")
  Future<BaseResponse> updateCategoryStep(
      @Body() ListingCategoryRequest request);

  @GET("frontoffice/api/common/status-quos")
  Future<BaseResponse<List<StatusQuos>>> getListStatusQuos();

  @GET("frontoffice/api/common/buy-plan-options")
  Future<BaseResponse<List<HomeDirection>>> getListPlanToBuy();

  @PUT("frontoffice/api/lso-listing-drafts/looking-question-step")
  Future<BaseResponse> updatePlanToBuy(@Body() ListingPlanToBuy request);

  @GET("frontoffice/api/use-right-types")
  Future<BaseResponse<List<HomeDirection>>> getListUseRightType();

  @PUT("frontoffice/api/lso-listing-drafts/area-and-direction-step")
  Future<BaseResponse> updateAreaDirectionStep(
      @Body() ListingAreaDirectionRequest request);

  @PUT("frontoffice/api/lso-listing-drafts/legal-documents-and-status-step")
  Future<BaseResponse> updateLegalDocsStep(
      @Body() ListingLegalDocsRequest request);

  @PUT("frontoffice/api/lso-listing-drafts/position-step")
  Future<BaseResponse> updatePositionStep(
      @Body() ListingPositionRequest request);

  @PUT("frontoffice/api/lso-listing-drafts/image-upload-step")
  Future<BaseResponse> updateImageStep(@Body() ListingImageRequest request);

  @GET("frontoffice/api/map/search")
  Future<BaseResponse<List<SearchAddress>>> searchAddressSuggestion(
      @Query("keyword") String textSearch);

  @GET("frontoffice/api/map/information")
  Future<BaseResponse<AddressByLocation>> getLocationInformation(
      @Query("location") String location);

  @POST("frontoffice/api/lso-listing-drafts")
  Future<BaseResponse<CreateListingResponse>> createListing(
    @Body() CreateListingRequest createListingRequest,
  );

  @PUT("frontoffice/api/lso-listing-drafts/address-step")
  Future<BaseResponse<dynamic>> updateAddressListing(
      @Body() CreateListingRequest request);

  @PUT("frontoffice/api/lso-listing-drafts/map-step")
  Future<BaseResponse<dynamic>> updateMapListing(
      @Body() UpdateMapListingRequest request);

  @PUT("frontoffice/api/lso-listing-drafts/owner-information-step")
  Future<BaseResponse<dynamic>> updateOwnerInfo(
      @Body() UpdateOwnerInfoListingRequest request);

  @PUT("frontoffice/api/lso-listing-drafts/more-information-step")
  Future<BaseResponse<dynamic>> updateUtilities(
      @Body() UpdateUtilitiesListingRequest request);

  @GET("/frontoffice/api/lso-listing-drafts/{id}")
  Future<BaseResponse<DraftListing>> getDraftListingDetail(
      @Path("id") int listingId);

  @PUT('frontoffice/api/lso-listing-drafts/texture-step')
  Future<BaseResponse<dynamic>> updateTextureStep(
    @Body() ListingTextureRequest request,
  );

  @PUT('frontoffice/api/lso-listing-drafts/title-and-description-step')
  Future<BaseResponse<dynamic>> updateTitleDescriptionStep(
    @Body() ListingTitleDescriptionRequest request,
  );

  @PUT('frontoffice/api/lso-listing-drafts/price-step')
  Future<BaseResponse<dynamic>> updatePriceStep(
    @Body() ListingPriceRequest request,
  );
}
