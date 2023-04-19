import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:propzy_home/src/domain/model/failure.dart';
import 'package:propzy_home/src/domain/model/project_property_type_model.dart';
import 'package:propzy_home/src/domain/repository/search_repository.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';

import '../../model/property_type_model.dart';

class GetPropertyTypeListProjectUseCase extends BaseUseCase<List<PropertyType>?, int> {
  GetPropertyTypeListProjectUseCase(this.searchRepository);

  final SearchRepository searchRepository;

  @override
  Future<Either<Failure, List<PropertyType>?>> call(int? params) async {
    try {
      final res = await searchRepository.getListPropertyTypesForProjectCategoryFilter(params);
      List<PropertyType> data = [];
      res.data?.forEach((e) {
        PropertyType item = PropertyType(id: e.id.toString(), name: e.name, isChecked: e.isChecked);
        data.add(item);
      });

      return Right(data);
    } on DioError catch (error) {
      return Left(Failure(message: error.message));
    } on Exception catch (_) {
      return const Left(Failure());
    }
  }
}
