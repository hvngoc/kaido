import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/domain/usecase/propzy_home/get_list_property_type_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_type/property_type_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_type/property_type_state.dart';

class PropzyHomePropertyTypeBloc
    extends Bloc<PropzyHomePropertyTypeEvent, PropzyHomePropertyTypeState> {
  PropzyHomePropertyTypeBloc() : super(InitialPropzyHomePropertyTypeState());

  final GetListPropertyTypeUseCase getListPropertyTypeUseCase =
      GetIt.instance.get<GetListPropertyTypeUseCase>();

  @override
  Stream<PropzyHomePropertyTypeState> mapEventToState(PropzyHomePropertyTypeEvent event) async* {
    if (event is GetPropertyTypeEvent) {
      yield* getListPropertyType();
    }
  }

  Stream<PropzyHomePropertyTypeState> getListPropertyType() async* {
    yield LoadingState();
    try {
      BaseResponse<List<PropzyHomePropertyType>> response =
          await getListPropertyTypeUseCase.getListPropertyType();
      if (response.result == true) {
        yield SuccessGetPropertyTypeState(response.data);
      } else {
        yield ErrorGetPropertyTypeState(message: response.message);
      }
    } catch (ex) {
      yield ErrorGetPropertyTypeState(message: ex.toString());
    }
  }
}
