import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:propzy_home/src/domain/usecase/auth_use_case.dart';
import 'package:propzy_home/src/util/constants.dart';

part 'ibuy_landing_page_event.dart';

part 'ibuy_landing_page_state.dart';

class IbuyLandingPageBloc extends Bloc<IbuyLandingPageEvent, IbuyLandingPageState> {
  IbuyLandingPageBloc() : super(IbuyLandingPageInitial()) {
    on<IbuyLandingPageSingleSignOnRequestEvent>(_onSingleSignOn);
  }

  final SingleSignOnUseCase _singleSignOnUseCase = GetIt.instance.get<SingleSignOnUseCase>();

  FutureOr<void> _onSingleSignOn(
    IbuyLandingPageSingleSignOnRequestEvent event,
    Emitter<IbuyLandingPageState> emit,
  ) async {
    emit(IbuyLandingPageLoadingState());
    final userInfo = await _singleSignOnUseCase.singleSignOn(SSOActionType.loginSMS);
    if (userInfo != null) {
      emit(IbuyLandingPageSuccessSingleSignOnState(event.isGoToIBuy));
    } else {
      emit(IbuyLandingPageErrorSingleSignOnState());
    }
  }
}
