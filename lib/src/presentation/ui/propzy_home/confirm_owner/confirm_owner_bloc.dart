import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/owner_type_model.dart';
import 'package:propzy_home/src/domain/usecase/auth_use_case.dart';
import 'package:propzy_home/src/domain/usecase/propzy_home/get_list_owner_type_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/confirm_owner/confirm_owner_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/confirm_owner/confirm_owner_state.dart';
import 'package:propzy_home/src/util/constants.dart';

class ConfirmOwnerBloc extends Bloc<ConfirmOwnerEvent, ConfirmOwnerState> {
  ConfirmOwnerBloc() : super(InitialConfirmOwnerState());

  final GetListOwnerTypeUseCase getListOwnerTypeUseCase =
      GetIt.instance.get<GetListOwnerTypeUseCase>();
  final SingleSignOnUseCase _singleSignOnUseCase = GetIt.instance.get<SingleSignOnUseCase>();

  @override
  Stream<ConfirmOwnerState> mapEventToState(ConfirmOwnerEvent event) async* {
    if (event is GetListOwnerTypeEvent) {
      yield* getListOwnerType();
    } else if (event is SingleSignOnRequestEvent) {
      yield* _onSingleSignOn();
    }
  }

  Stream<ConfirmOwnerState> _onSingleSignOn() async* {
    final userInfo = await _singleSignOnUseCase.singleSignOn(SSOActionType.loginSMS);
    if (userInfo != null) {
      yield SuccessSingleSignOnState();
    } else {
      yield ErrorSingleSignOnState();
    }
  }

  Stream<ConfirmOwnerState> getListOwnerType() async* {
    yield LoadingGetListOwnerTypeState();
    try {
      BaseResponse<List<OwnerType>> response = await getListOwnerTypeUseCase.getListOwnerType();
      if (response.result == true) {
        yield SuccessGetListOwnerTypeState(response.data);
      } else {
        yield ErrorConfirmOwnerState(response.message);
      }
    } catch (ex) {
      yield ErrorConfirmOwnerState(ex.toString());
    }
  }
}
