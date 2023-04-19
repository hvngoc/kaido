import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/category_home_listing.dart';
import 'package:propzy_home/src/domain/model/category_home_project.dart';
import 'package:propzy_home/src/domain/usecase/get_listing_search_home.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_bloc.dart';

class ResultProjectBloc extends BaseResultBloc<CategoryHomeProject> {
  @override
  BaseGetListingSearchUseCase<CategoryHomeProject> getGetListingSearchHomeUseCase =
      GetIt.instance.get<GetCategoryProjectSearchHomeUseCase>();
}
