import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:propzy_home/src/domain/repository/search_repository.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';

import '../../model/common_model.dart';
import '../../model/failure.dart';

class GetDirectionListUseCase extends BaseUseCase<List<Direction>?, NoParams> {
  GetDirectionListUseCase(this.searchRepository);

  final SearchRepository searchRepository;

  @override
  Future<Either<Failure, List<Direction>?>> call(NoParams? params) async {
    try {
      final res = await searchRepository.getListDirectionCategoryFilter();

      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}
