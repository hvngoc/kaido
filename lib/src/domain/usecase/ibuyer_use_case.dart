import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/failure.dart';
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
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';

class GetListParentHouseUseCase extends BaseUseCase<List<HomeFeature>?, NoParams> {
  late final IBuyerRepository _repository;

  GetListParentHouseUseCase(this._repository);

  @override
  Future<Either<Failure, List<HomeFeature>?>> call(NoParams? params) async {
    try {
      final res = await _repository.getListParentHouseTexture();
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListContiguousUseCase extends BaseUseCase<List<HomeContiguous>?, int> {
  late final IBuyerRepository _repository;

  GetListContiguousUseCase(this._repository);

  @override
  Future<Either<Failure, List<HomeContiguous>?>> call(int? params) async {
    try {
      final res = await _repository.getListContiguousByType(params ?? 1);
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListHouseShapeUseCase extends BaseUseCase<List<HomeDirection>?, NoParams> {
  late final IBuyerRepository _repository;

  GetListHouseShapeUseCase(this._repository);

  @override
  Future<Either<Failure, List<HomeDirection>?>> call(NoParams? params) async {
    try {
      final res = await _repository.getListHouseShape();
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListHouseDirectionUseCase extends BaseUseCase<List<HomeDirection>?, NoParams> {
  @override
  Future<Either<Failure, List<HomeDirection>?>> call(NoParams? params) async {
    try {
      List<HomeDirection> res = [
        HomeDirection(1, 'Đông'),
        HomeDirection(2, 'Tây'),
        HomeDirection(3, 'Nam'),
        HomeDirection(4, 'Bắc'),
        HomeDirection(5, 'Đông Bắc'),
        HomeDirection(6, 'Tây Bắc'),
        HomeDirection(7, 'Đông Nam'),
        HomeDirection(8, 'Tây Nam'),
      ];
      return Right(res);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListExpectedTimeUseCase extends BaseUseCase<List<HomeDirection>?, NoParams> {
  late final IBuyerRepository _repository;

  GetListExpectedTimeUseCase(this._repository);

  @override
  Future<Either<Failure, List<HomeDirection>?>> call(NoParams? params) async {
    try {
      final res = await _repository.getListExpectedTime();
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListCaptionUseCase extends BaseUseCase<List<HomeCaptionMediaModel>?, NoParams> {
  late final IBuyerRepository _repository;

  GetListCaptionUseCase(this._repository);

  @override
  Future<Either<Failure, List<HomeCaptionMediaModel>?>> call(NoParams? params) async {
    try {
      final res = await _repository.getListCaption();
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetOfferDetailUseCase extends BaseUseCase<HomeOfferModel?, int> {
  late final IBuyerRepository _repository;

  GetOfferDetailUseCase(this._repository);

  @override
  Future<Either<Failure, HomeOfferModel?>> call(int? params) async {
    try {
      final res = await _repository.getOfferDetail(params ?? 0);
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class UpdateOfferUseCase extends BaseUseCase<BaseResponse?, PropzyHomeUpdateOfferRequest> {
  late final IBuyerRepository _repository;

  UpdateOfferUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse?>> call(PropzyHomeUpdateOfferRequest? params) async {
    try {
      final res = await _repository.updateOffer(params ?? PropzyHomeUpdateOfferRequest());
      return Right(res);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class CreateOfferUseCase {
  late final IBuyerRepository _repository;

  CreateOfferUseCase(this._repository);

  Future<BaseResponse<int>> createOffer(PropzyHomeCreateOfferRequest request) {
    return _repository.createOffer(request);
  }
}

class UploadFileUseCase {
  late final IBuyerRepository _repository;

  UploadFileUseCase(this._repository);

  Future<BaseResponse<int>> uploadFile(PropzyHomeUploadFileRequest request) {
    return _repository.uploadFile(request);
  }
}

class DeleteFileUseCase {
  late final IBuyerRepository _repository;

  DeleteFileUseCase(this._repository);

  Future<BaseResponse<int>> deleteFile(int id) {
    return _repository.deleteFile(id);
  }
}

class CallScheduleOfferUseCase {
  late final IBuyerRepository _repository;

  CallScheduleOfferUseCase(this._repository);

  Future<BaseResponse<int?>> scheduleOffer(HomeScheduleOfferModel params) {
    return _repository.scheduleOffer(params);
  }
}

class UpdateCaptionFileUseCase {
  late final IBuyerRepository _repository;

  UpdateCaptionFileUseCase(this._repository);

  Future<BaseResponse<int>> updateCaptionFile(PropzyHomeUpdateCaptionRequest request) {
    return _repository.updateCaptionFile(request);
  }
}

class GetOfferPriceUseCase {
  late final IBuyerRepository _repository;

  GetOfferPriceUseCase(this._repository);

  Future<BaseResponse<PropzyHomeOfferPriceModel>> getOfferPrice(
    int offerId,
  ) {
    return _repository.getOfferPrice(offerId);
  }
}

class GetCompletionPercentageUseCase {
  late final IBuyerRepository _repository;

  GetCompletionPercentageUseCase(this._repository);

  Future<BaseResponse<PropzyHomeProgressPercentageModel>> getCompletionPercentage(
    int offerId,
  ) {
    return _repository.getCompletionPercentage(offerId);
  }
}

class GetProcessOfferUseCase {
  late final IBuyerRepository _repository;

  GetProcessOfferUseCase(this._repository);

  Future<BaseResponse<List<PropzyHomeProcessModel>>> getProcessOffer(
    int offerId,
  ) {
    return _repository.getProcessOffer(offerId);
  }
}

class GetListPlanToBuyUseCase extends BaseUseCase<List<HomeDirection>?, NoParams> {
  @override
  Future<Either<Failure, List<HomeDirection>?>> call(NoParams? params) async {
    try {
      List<HomeDirection> res = [
        HomeDirection(1, 'Chắc chắn sẽ mua'),
        HomeDirection(2, 'Chưa có nhu cầu'),
        HomeDirection(3, 'Vẫn đang suy nghĩ'),
      ];
      return Right(res);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListingInDistanceUseCase {
  late final IBuyerRepository _repository;

  GetListingInDistanceUseCase(this._repository);

  Future<BaseResponse<List<PropzyHomeMarkerModel>>> getListingInDistance(
    RequestListingInDistanceModel request,
  ) {
    return _repository.getListingInDistance(request);
  }
}

class GetListCategoriesOfferUseCase {
  late final IBuyerRepository _repository;

  GetListCategoriesOfferUseCase(this._repository);

  Future<BaseResponse<List<PropzyHomeCategoryOffer>>> getListCategoriesOffer() {
    return _repository.getListCategoriesOffer();
  }
}

class GetListOffersByCategoryUseCase {
  late final IBuyerRepository _repository;

  GetListOffersByCategoryUseCase(this._repository);

  Future<BaseResponse<PagingResponse<HomeOfferModel>>> getListOffersByCategory(
    int categoryId,
    int page,
    int size,
  ) {
    return _repository.getListOffersByCategory(
      categoryId,
      page,
      size,
    );
  }
}
