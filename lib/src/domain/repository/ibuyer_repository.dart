import 'dart:io';

import 'package:propzy_home/src/data/model/base_response.dart';
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
import 'package:propzy_home/src/domain/request/propzy_home_create_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_home_upload_file_request.dart';

abstract class IBuyerRepository {
  Future<BaseResponse<List<HomeFeature>>> getListParentHouseTexture();

  Future<BaseResponse<List<HomeContiguous>>> getListContiguousByType(int type);

  Future<BaseResponse<List<HomeDirection>>> getListHouseShape();

  Future<BaseResponse<List<HomeDirection>>> getListExpectedTime();

  Future<BaseResponse<List<HomeCaptionMediaModel>>> getListCaption();

  Future<BaseResponse<HomeOfferModel>> getOfferDetail(int offerId);

  Future<BaseResponse> updateOffer(PropzyHomeUpdateOfferRequest request);

  Future<BaseResponse<int>> createOffer(PropzyHomeCreateOfferRequest request);

  Future<BaseResponse<int>> uploadFile(PropzyHomeUploadFileRequest request);

  Future<BaseResponse<int>> deleteFile(int id);

  Future<BaseResponse<int>> scheduleOffer(HomeScheduleOfferModel request);

  Future<BaseResponse<int>> updateCaptionFile(PropzyHomeUpdateCaptionRequest request);

  Future<BaseResponse<PropzyHomeOfferPriceModel>> getOfferPrice(int offerId);

  Future<BaseResponse<PropzyHomeProgressPercentageModel>> getCompletionPercentage(int offerId);

  Future<BaseResponse<List<PropzyHomeProcessModel>>> getProcessOffer(int offerId);

  Future<BaseResponse<List<PropzyHomeMarkerModel>>> getListingInDistance(
    RequestListingInDistanceModel request,
  );

  Future<BaseResponse<List<PropzyHomeCategoryOffer>>> getListCategoriesOffer();

  Future<BaseResponse<PagingResponse<HomeOfferModel>>> getListOffersByCategory(
    int categoryId,
    int page,
    int size,
  );
}
