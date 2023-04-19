import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:propzy_home/src/domain/model/common_model.dart';

import '../../model/failure.dart';
import '../../repository/search_repository.dart';
import '../base_usecase.dart';

class GetAmenityCategoryListUseCase extends BaseUseCase<List<Amenity>?, NoParams> {
  GetAmenityCategoryListUseCase(this.searchRepository);

  final SearchRepository searchRepository;

  @override
  Future<Either<Failure, List<Amenity>?>> call(NoParams? params) async {
    try {
      final res = await searchRepository.getListAmenityCategoryFilter();

      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}