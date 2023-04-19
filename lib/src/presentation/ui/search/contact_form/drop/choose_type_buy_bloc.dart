import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/category_properties.dart';
import 'package:propzy_home/src/domain/usecase/get_chooser_list_use_case.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class ChooserPropertiesBuyBloc extends ChooserBloc<CategoryProperties> {
  ChooserPropertiesBuyBloc() : super();

  @override
  GetChooserListUseCase<CategoryProperties> useCase =
      GetIt.instance.get<GetListPropertyBuyUseCase>();

  @override
  ChooserData convertResponse(CategoryProperties item) => ChooserData(item.id, item.name);
}
