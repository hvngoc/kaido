import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/usecase/get_chooser_list_use_case.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class ChooserDistrictBloc extends ChooserBloc<District> {
  ChooserDistrictBloc() : super();

  @override
  GetChooserListUseCase<District> useCase = GetIt.instance.get<GetListDistrictUseCase>();

  @override
  ChooserData convertResponse(District item) => ChooserData(item.districtId, item.districtName);
}
