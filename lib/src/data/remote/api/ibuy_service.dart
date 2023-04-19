import 'dart:io';

import 'package:dio/dio.dart';
import 'package:propzy_home/src/domain/model/propzy_home_process_model.dart';
import 'package:retrofit/http.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/owner_type_model.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_contiguous.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/model/propzy_home_feature.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_price_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_progress_percentage_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/domain/model/propzy_map_model.dart';
import 'package:propzy_home/src/domain/model/request_listing_in_distance_model.dart';
import 'package:propzy_home/src/domain/request/propzy_home_create_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_map_request.dart';
import 'package:propzy_home/src/domain/model/propzy_home_marker_model.dart';

part 'ibuy_service.g.dart';

@RestApi()
abstract class IbuyService {
  factory IbuyService(Dio dio) = _IbuyService;

  static const String PREFIX_IBUY = "ibuy/api/";
  static const String PREFIX_MOBILE = "mobile/api/";

  @POST("${PREFIX_MOBILE}location/getListingInDistance")
  Future<BaseResponse<List<PropzyHomeMarkerModel>>> getListingInDistance(
    @Body(nullToAbsent: true) RequestListingInDistanceModel request,
  );

  @GET("${PREFIX_IBUY}common/check-update-version")
  Future<BaseResponse> checkUpdateVersion();

  @GET("${PREFIX_IBUY}common/getListPropertyType")
  Future<BaseResponse<List<PropzyHomePropertyType>>> getListPropertyType();

  @GET("${PREFIX_IBUY}map/account/auth/session")
  Future<BaseResponse<PropzyMapSession>> getPropzyMapSession();

  @GET("${PREFIX_IBUY}map/geographic/search")
  Future<BaseResponse<AddressSearchContent>> searchAddressPropzyMap(
    @Query("address") String address,
    @Query("page") int page,
    @Query("size") int size,
    @Query("property_type_id") int property_type_id,
    @Query("sort") String? sort,
  );

  @POST("${PREFIX_IBUY}map/geographic/property/information")
  Future<BaseResponse<List<AddressInformation>?>> getAddressInformation(
    @Body(nullToAbsent: true) PropzyMapInformationRequest request,
  );

  @GET("${PREFIX_IBUY}map/geographic/street/predict-location/{streetId}")
  Future<BaseResponse<PredictLocation?>> predictLocation(@Path("streetId") int streetId);

  @POST("${PREFIX_IBUY}map/geographic/landplot/search-with-street")
  Future<BaseResponse<PagingResponse<SearchAddressWithStreet>>> searchAddressWithStreet(
    @Query("page") int page,
    @Query("size") int size,
    @Body(nullToAbsent: true) SearchAddressWithStreetRequest request,
  );

  @GET("${PREFIX_IBUY}common/getListParentHouseTexture")
  Future<BaseResponse<List<HomeFeature>>> getListParentHouseTexture();

  @GET("${PREFIX_IBUY}common/getListContiguousByType")
  Future<BaseResponse<List<HomeContiguous>>> getListContiguousByType(
    @Query("typeId") int typeId,
  );

  @GET("${PREFIX_IBUY}common/get-list-house-shape")
  Future<BaseResponse<List<HomeDirection>>> getListHouseShape();

  @GET("${PREFIX_IBUY}common/getListExpectedTime")
  Future<BaseResponse<List<HomeDirection>>> getListExpectedTime();

  @GET("${PREFIX_IBUY}common/getListCaption")
  Future<BaseResponse<List<HomeCaptionMediaModel>>> getListCaption();

  @PUT("${PREFIX_IBUY}offer")
  Future<BaseResponse> updateOffer(
      @Body(nullToAbsent: true) PropzyHomeUpdateOfferRequest propzyHomeOffer);

  @POST("${PREFIX_IBUY}offer")
  Future<BaseResponse<int>> createOffer(
      @Body(nullToAbsent: true) PropzyHomeCreateOfferRequest request);

  @POST("${PREFIX_IBUY}offer/uploadFile")
  @MultiPart()
  Future<BaseResponse<int>> uploadFile(
    @Part(name: 'file') File file,
    @Part(name: 'captionId') int? captionId,
    @Part(name: 'offerId') int? offerId,
    @Part(name: 'id') int? id,
    @Part(name: 'typeSource') int? typeSource,
    @Part(name: 'typeFile') int? typeFile,
  );

  @POST("${PREFIX_IBUY}offer/deleteFile")
  Future<BaseResponse<int>> deleteFile(
    @Query("id") int id,
  );

  @GET("${PREFIX_IBUY}offer/{offerId}")
  Future<BaseResponse<HomeOfferModel>> getOfferDetail(
    @Path("offerId") int offerId,
  );

  @POST("${PREFIX_IBUY}offer/schedule")
  Future<BaseResponse<int>> scheduleOffer(
    @Body(nullToAbsent: true) HomeScheduleOfferModel request,
  );

  @POST("${PREFIX_IBUY}offer/update-caption-file")
  Future<BaseResponse<int>> updateCaptionFile(
    @Body(nullToAbsent: true) PropzyHomeUpdateCaptionRequest request,
  );

  @GET("${PREFIX_IBUY}offer/{offerId}/pricing")
  Future<BaseResponse<PropzyHomeOfferPriceModel>> getOfferPrice(
    @Path("offerId") int offerId,
  );

  @GET("${PREFIX_IBUY}offer/{offerId}/completion-percentage")
  Future<BaseResponse<PropzyHomeProgressPercentageModel>> getCompletionPercentage(
    @Path("offerId") int offerId,
  );

  @GET("${PREFIX_IBUY}offer/{offerId}/process")
  Future<BaseResponse<List<PropzyHomeProcessModel>>> getProcessOffer(
    @Path("offerId") int offerId,
  );

  @GET("${PREFIX_IBUY}common/getListOwnerType")
  Future<BaseResponse<List<OwnerType>>> getListOwnerType();

  @GET("${PREFIX_IBUY}offer/categories")
  Future<BaseResponse<List<PropzyHomeCategoryOffer>>> getListCategoriesOffer();

  @GET("${PREFIX_IBUY}offer/get-list-offer-by-category")
  Future<BaseResponse<PagingResponse<HomeOfferModel>>> getListOffersByCategory(
    @Query("categoryId") int categoryId,
    @Query("page") int page,
    @Query("size") int size,
  );
}
