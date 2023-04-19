import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:propzy_home/src/domain/model/common_model.dart';
import 'package:propzy_home/src/util/message_util.dart';

import '../../model/failure.dart';
import '../../repository/search_repository.dart';
import '../base_usecase.dart';

class GetAdvantageCategoryListUseCase extends BaseUseCase<List<Advantage>?, NoParams> {
  GetAdvantageCategoryListUseCase(this.searchRepository);

  final SearchRepository searchRepository;

  @override
  Future<Either<Failure, List<Advantage>?>> call(NoParams? params) async {
    try {
      final res = await searchRepository.getListAdvantageCategoryFilter();
      if (res.result == true) {
        return Right(res.data);
      } else {
        return Left(Failure(message: res.message ?? MessageUtil.errorMessageDefault));
      }
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}
