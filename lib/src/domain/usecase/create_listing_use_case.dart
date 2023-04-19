import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/failure.dart';
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

class UpdateCategoryListingUseCase {
  late final ListingRepository _repository;

  UpdateCategoryListingUseCase(this._repository);

  Future<Either<Failure, dynamic>> updateCategory(
    int listingId,
    int listingTypeId,
    int? propertyTypeId,
  ) async {
    final request = ListingCategoryRequest(
      id: listingId,
      listingTypeId: listingTypeId,
      propertyTypeId: propertyTypeId,
    );

    try {
      final res = await _repository.updateCategoryStep(request);

      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class SearchAddressListingUseCase {
  late final ListingRepository _repository;

  SearchAddressListingUseCase(this._repository);

  Future<BaseResponse<List<SearchAddress>>> searchAddressSuggestion(
      String textSearch) {
    return _repository.searchAddressSuggestion(textSearch);
  }
}

class GetLocationInformationUseCase {
  late final ListingRepository _repository;

  GetLocationInformationUseCase(this._repository);

  Future<BaseResponse<AddressByLocation>> getLocationInformation(
      String location) {
    return _repository.getLocationInformation(location);
  }
}

class GetDraftListingDetailUseCase {
  late final ListingRepository _repository;

  GetDraftListingDetailUseCase(this._repository);

  Future<BaseResponse<DraftListing>> getDraftListingDetail(int listingId) {
    return _repository.getDraftListingDetail(listingId);
  }
}

class CreateListingUseCase {
  late final ListingRepository _repository;

  CreateListingUseCase(this._repository);

  Future<BaseResponse<CreateListingResponse>> createListing(
      CreateListingRequest request) {
    return _repository.createListing(request);
  }
}

class UpdateAddressListingUseCase {
  late final ListingRepository _repository;

  UpdateAddressListingUseCase(this._repository);

  Future<BaseResponse<dynamic>> updateAddressListing(
      CreateListingRequest request) {
    return _repository.updateAddressListing(request);
  }

  Future<BaseResponse<dynamic>> updateMapListing(
      UpdateMapListingRequest request) {
    return _repository.updateMapListing(request);
  }
}

class UpdateAreaDirectionListingUseCase {
  late final ListingRepository _repository;

  UpdateAreaDirectionListingUseCase(this._repository);

  Future<Either<Failure, dynamic>> update(
      int? id,
      int? bathrooms,
      int? bedrooms,
      int? directionId,
      double? floorSize,
      double? lotSize,
      double? sizeLength,
      double? sizeWidth) async {
    final request = ListingAreaDirectionRequest(
        id: id,
        bathrooms: bathrooms,
        bedrooms: bedrooms,
        directionId: directionId,
        floorSize: floorSize,
        lotSize: lotSize,
        sizeLength: sizeLength,
        sizeWidth: sizeWidth);

    try {
      final res = await _repository.updateAreaDirectionStep(request);

      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class UpdateLegalDocsListingUseCase {
  late final ListingRepository _repository;

  UpdateLegalDocsListingUseCase(this._repository);

  Future<Either<Failure, dynamic>> update(
    int? id,
    int? priceForStatusQuo,
    int? statusQuoId,
    int? useRightTypeId,
  ) async {
    final request = ListingLegalDocsRequest(
      id: id,
      priceForStatusQuo: priceForStatusQuo,
      statusQuoId: statusQuoId,
      useRightTypeId: useRightTypeId,
    );

    try {
      final res = await _repository.updateLegalDocsStep(request);

      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListStatusQuos {
  late final ListingRepository _repository;

  GetListStatusQuos(this._repository);

  Future<Either<Failure, List<StatusQuos>?>> getList() async {
    try {
      final res = await _repository.getListStatusQuos();
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListPlanToBuyServicesUseCase {
  late final ListingRepository _repository;

  GetListPlanToBuyServicesUseCase(this._repository);

  Future<Either<Failure, List<HomeDirection>?>> getList() async {
    try {
      final res = await _repository.getListPlanToBuy();
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class UpdatePlanToBuyListingUseCase {
  late final ListingRepository _repository;

  UpdatePlanToBuyListingUseCase(this._repository);

  Future<Either<Failure, dynamic>> update(
    int? id,
    int? buyPlanOptionId,
    int? districtId,
    int? priceFrom,
    int? priceTo,
    int? propertyTypeId,
  ) async {
    final request = ListingPlanToBuy(
      id: id,
      buyPlanOptionId: buyPlanOptionId,
      districtId: districtId,
      priceFrom: priceFrom,
      priceTo: priceTo,
      propertyTypeId: propertyTypeId,
    );

    try {
      final res = await _repository.updatePlanToBuy(request);
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListUseRightType {
  late final ListingRepository _repository;

  GetListUseRightType(this._repository);

  Future<Either<Failure, List<HomeDirection>?>> getList() async {
    try {
      final res = await _repository.getListUseRightType();
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class UpdatePositionListingUseCase {
  late final ListingRepository _repository;

  UpdatePositionListingUseCase(this._repository);

  Future<Either<Failure, dynamic>> update(
    int? id,
    String? currentStep,
    int? positionId,
    double? roadFrontageWidth,
    int? alleyId,
    double? roadFrontageDistanceFrom,
    double? roadFrontageDistanceTo,
  ) async {
    final request = ListingPositionRequest(
      id: id,
      currentStep: currentStep,
      positionId: positionId,
      roadFrontageWidth: roadFrontageWidth,
      alleyId: alleyId,
      roadFrontageDistanceFrom: roadFrontageDistanceFrom,
      roadFrontageDistanceTo: roadFrontageDistanceTo,
    );
    try {
      final res = await _repository.updatePositionStep(request);
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class UpdateProjectInfoListingUseCase {
  late final ListingRepository _repository;

  UpdateProjectInfoListingUseCase(this._repository);

  Future<Either<Failure, dynamic>> update(
    int? id,
    String? currentStep,
    int? buildingId,
    String? buildingName,
    int? floor,
    String? modelCode,
    bool? isHideModelCode,
  ) async {
    final request = ListingPositionRequest(
      id: id,
      currentStep: currentStep,
      buildingId: buildingId,
      buildingName: buildingName,
      floor: floor,
      modelCode: modelCode,
      isHideModelCode: isHideModelCode,
    );
    try {
      final res = await _repository.updatePositionStep(request);
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class UpdateImageListingUseCase {
  late final ListingRepository _repository;

  UpdateImageListingUseCase(this._repository);

  Future<Either<Failure, dynamic>> update(
    int? id,
    String? currentStep,
    List<ListingMediaRequest>? media,
  ) async {
    final request = ListingImageRequest(
      id: id,
      currentStep: currentStep,
      media: media,
    );
    try {
      final res = await _repository.updateImageStep(request);
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class UpdateOwnerInfoListingUseCase {
  late final ListingRepository _repository;

  UpdateOwnerInfoListingUseCase(this._repository);

  Future<BaseResponse<dynamic>> updateOwnerInfo(
      UpdateOwnerInfoListingRequest request) {
    return _repository.updateOwnerInfo(request);
  }
}

class UpdateUtilitiesListingUseCase {
  late final ListingRepository _repository;

  UpdateUtilitiesListingUseCase(this._repository);

  Future<BaseResponse<dynamic>> updateUtilities(
      UpdateUtilitiesListingRequest request) {
    return _repository.updateUtilities(request);
  }
}

class UpdateTextureStepUseCase {
  late final ListingRepository _repository;

  UpdateTextureStepUseCase(this._repository);

  Future<BaseResponse<dynamic>> updateTextureStep(
    ListingTextureRequest request,
  ) {
    return _repository.updateTextureStep(
      request,
    );
  }
}

class UpdateTitleDescriptionStepUseCase {
  late final ListingRepository _repository;

  UpdateTitleDescriptionStepUseCase(this._repository);

  Future<Either<Failure, dynamic>> updateTitleDescriptionStep(
    ListingTitleDescriptionRequest request,
  ) async {
    try {
      final res = await _repository.updateTitleDescriptionStep(request);
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class UpdatePriceStepUseCase {
  late final ListingRepository _repository;

  UpdatePriceStepUseCase(this._repository);

  Future<BaseResponse<dynamic>> updatePriceStep(
    ListingPriceRequest request,
  ) {
    return _repository.updatePriceStep(
      request,
    );
  }
}
