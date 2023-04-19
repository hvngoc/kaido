import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:propzy_home/src/domain/repository/search_repository.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';

import '../../model/failure.dart';
import '../../model/property_type_model.dart';

class GetPropertyTypeListUseCase extends BaseUseCase<List<PropertyType>?, int> {
  GetPropertyTypeListUseCase(this.searchRepository);

  final SearchRepository searchRepository;

  @override
  Future<Either<Failure, List<PropertyType>?>> call(int? params) async {
    try {
      final res =
          await searchRepository.getListPropertyTypesCategoryFilter(params);

      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}
