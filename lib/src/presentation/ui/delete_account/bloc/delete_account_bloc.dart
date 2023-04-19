import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/domain/model/delete_account_info.dart';
import 'package:propzy_home/src/domain/request/delete_account_request.dart';
import 'package:propzy_home/src/domain/usecase/delete_account_use_case.dart';
import 'package:propzy_home/src/util/message_util.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc() : super(DeleteAccountInitial()) {
    on<DeleteAccountEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetDeleteAccountInfoEvent>(_onGetDeleteAccountInfo);
    on<RequestDeleteAccountEvent>(_onRequestDeleteAccount);
    on<CancelDeleteAccountEvent>(_onCancelDeleteAccount);
  }

  final DeleteAccountUseCase _deleteAccountUseCase =
      GetIt.I.get<DeleteAccountUseCase>();
  final PrefHelper _prefHelper = GetIt.I.get<PrefHelper>();

  void _onGetDeleteAccountInfo(
    GetDeleteAccountInfoEvent event,
    Emitter<DeleteAccountState> emitter,
  ) async {
    emitter(
      DeleteAccountLoadingState(),
    );

    final response = await _deleteAccountUseCase.getDeletionInfo();
    final DeleteAccountInfo? deleteInfo = response.data;

    if (!response.isSuccess()) {
      emitter(
        DeleteAccountErrorState(
          response.message ?? MessageUtil.errorMessageDefault,
        ),
      );
      return;
    }

    if (deleteInfo != null) {
      if (deleteInfo.status == 'DELETED') {
        emitter(
          GetDeleteAccountInfoSuccessState(
            DeleteAccountStatus.deleted,
            deleteInfo,
          ),
        );
        return;
      }
      if (deleteInfo.reqDeleteAt != null) {
        emitter(
          GetDeleteAccountInfoSuccessState(
            DeleteAccountStatus.countDown,
            deleteInfo,
          ),
        );
      } else {
        emitter(
          GetDeleteAccountInfoSuccessState(
            DeleteAccountStatus.confirm,
            deleteInfo,
          ),
        );
      }
    } else {
      emitter(
        DeleteAccountErrorState(
          response.message ?? MessageUtil.errorMessageDefault,
        ),
      );
    }
  }

  void _onRequestDeleteAccount(
    RequestDeleteAccountEvent event,
    Emitter<DeleteAccountState> emitter,
  ) async {
    emitter(
      DeleteAccountLoadingState(),
    );
    DeleteAccountRequest request = DeleteAccountRequest(
      event.password,
      event.reason,
    );
    final response = await _deleteAccountUseCase.sendDeleteRequest(request);
    if (response.isSuccess()) {
      emitter(SendDeleteSuccessState());
    } else {
      emitter(
        DeleteAccountErrorState(
          response.message ?? MessageUtil.errorMessageDefault,
        ),
      );
    }
  }

  void _onCancelDeleteAccount(
      CancelDeleteAccountEvent event,
      Emitter<DeleteAccountState> emitter,
      ) async {
    emitter(
      DeleteAccountLoadingState(),
    );
    final response = await _deleteAccountUseCase.cancelDeletion();
    if (response.isSuccess()) {
      emitter(CancelDeleteSuccessState());
    } else {
      emitter(
        DeleteAccountErrorState(
          response.message ?? MessageUtil.errorMessageDefault,
        ),
      );
    }
  }
}
