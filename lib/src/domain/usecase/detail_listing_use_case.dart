import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/failure.dart';
import 'package:propzy_home/src/domain/model/listing_alley.dart';
import 'package:propzy_home/src/domain/model/listing_building.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/repository/listing_repository.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';

class GetDetailListingUseCase {
  late final ListingRepository _repository;
  GetDetailListingUseCase(this._repository);

  Future<BaseResponse<Listing>> getDetailListing(int listingId) {
    return _repository.getDetailListing(listingId);
  }
}

class GetListingInteractionUseCase {
  late final ListingRepository _repository;
  GetListingInteractionUseCase(this._repository);

  Future<BaseResponse<ListingInteraction>> getListingInteraction(int listingId) {
    return _repository.getListingInteraction(listingId);
  }
}

class GetListAlleysUseCase extends BaseUseCase<List<ListingAlley>?, NoParams> {
  late final ListingRepository _repository;
  GetListAlleysUseCase(this._repository);

  @override
  Future<Either<Failure, List<ListingAlley>?>> call(NoParams? params) async {
    try {
      final res = await _repository.getListAlleys();
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}

class GetListBuildingsUseCase extends BaseUseCase<List<ListingBuilding>?, int> {
  late final ListingRepository _repository;
  GetListBuildingsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ListingBuilding>?>> call(int? districtId) async {
    try {
      final res = await _repository.getListBuildings(districtId ?? 1);
      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}