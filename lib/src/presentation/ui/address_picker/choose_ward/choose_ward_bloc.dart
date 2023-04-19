import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/city.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/ward.dart';
import 'package:propzy_home/src/domain/usecase/get_chooser_list_use_case.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class ChooserWardBloc extends ChooserBloc<Ward> {
  ChooserWardBloc() : super();

  @override
  GetChooserListUseCase<Ward> useCase = GetIt.instance.get<GetListWardUseCase>();

  @override
  ChooserData convertResponse(Ward item) => ChooserData(item.wardId, item.wardName);
}
