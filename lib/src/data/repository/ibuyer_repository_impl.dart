import 'dart:io';

import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/remote/api/ibuy_service.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_contiguous.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/model/propzy_home_feature.dart';
import 'package:propzy_home/src/domain/model/propzy_home_marker_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_price_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_process_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_progress_percentage_model.dart';
import 'package:propzy_home/src/domain/model/request_listing_in_distance_model.dart';
import 'package:propzy_home/src/domain/repository/ibuyer_repository.dart';
import 'package:propzy_home/src/domain/request/propzy_home_create_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_home_upload_file_request.dart';

class IBuyerRepositoryImpl implements IBuyerRepository {
  final IbuyService service;
  final PrefHelper prefHelper;

  IBuyerRepositoryImpl(this.service, this.prefHelper);

  @override
  Future<BaseResponse<List<HomeFeature>>> getListParentHouseTexture() {
    return service.getListParentHouseTexture();
  }

  @override
  Future<BaseResponse<List<HomeContiguous>>> getListContiguousByType(int type) {
    return service.getListContiguousByType(type);
  }

  @override
  Future<BaseResponse<List<HomeDirection>>> getListHouseShape() {
    return service.getListHouseShape();
  }

  @override
  Future<BaseResponse<List<HomeDirection>>> getListExpectedTime() {
    return service.getListExpectedTime();
  }

  @override
  Future<BaseResponse<List<HomeCaptionMediaModel>>> getListCaption() {
    return service.getListCaption();
  }

  @override
  Future<BaseResponse<HomeOfferModel>> getOfferDetail(int offerId) {
    return service.getOfferDetail(offerId);
  }

  @override
  Future<BaseResponse> updateOffer(PropzyHomeUpdateOfferRequest request) {
    return service.updateOffer(request);
  }

  @override
  Future<BaseResponse<int>> createOffer(PropzyHomeCreateOfferRequest request) {
    return service.createOffer(request);
  }

  @override
  Future<BaseResponse<int>> uploadFile(PropzyHomeUploadFileRequest request) {
    return service.uploadFile(
      request.file,
      request.captionId,
      request.offerId,
      request.id,
      request.typeSource,
      request.typeFile,
    );
  }

  @override
  Future<BaseResponse<int>> deleteFile(int id) {
    return service.deleteFile(id);
  }

  @override
  Future<BaseResponse<int>> scheduleOffer(HomeScheduleOfferModel request) {
    return service.scheduleOffer(request);
  }

  @override
  Future<BaseResponse<int>> updateCaptionFile(PropzyHomeUpdateCaptionRequest request) {
    return service.updateCaptionFile(request);
  }

  @override
  Future<BaseResponse<PropzyHomeOfferPriceModel>> getOfferPrice(int offerId) {
    return service.getOfferPrice(offerId);
  }

  @override
  Future<BaseResponse<PropzyHomeProgressPercentageModel>> getCompletionPercentage(int offerId) {
    return service.getCompletionPercentage(offerId);
  }

  @override
  Future<BaseResponse<List<PropzyHomeProcessModel>>> getProcessOffer(int offerId) {
    return service.getProcessOffer(offerId);
  }

  @override
  Future<BaseResponse<List<PropzyHomeMarkerModel>>> getListingInDistance(
    RequestListingInDistanceModel request,
  ) {
    return service.getListingInDistance(request);
  }

  @override
  Future<BaseResponse<List<PropzyHomeCategoryOffer>>> getListCategoriesOffer() {
    return service.getListCategoriesOffer();
  }

  @override
  Future<BaseResponse<PagingResponse<HomeOfferModel>>> getListOffersByCategory(
    int categoryId,
    int page,
    int size,
  ) {
    return service.getListOffersByCategory(
      categoryId,
      page,
      size,
    );
  }
}
