import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:propzy_home/src/domain/repository/search_repository.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';

import '../../model/common_model_1.dart';
import '../../model/failure.dart';

class GetBedRoomListUseCase extends BaseUseCase<List<BedRoom>?, NoParams> {
  GetBedRoomListUseCase(this.searchRepository);

  final SearchRepository searchRepository;

  @override
  Future<Either<Failure, List<BedRoom>?>> call(NoParams? params) async {
    try {
      final res = await searchRepository.getListBedroomCategoryFilter();
      res.data?.insert(0, BedRoom(null, null, "Tất cả", isSelected: false));

      return Right(res.data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}
