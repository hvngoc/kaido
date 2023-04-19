import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/listing_status_quos.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/legal_documents/bloc/legal_docs_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/legal_documents/bloc/legal_docs_state.dart';
import 'package:propzy_home/src/util/util.dart';

class LegalDocsBloc extends Bloc<LegalDocsEvent, BaseLegalDocsState> {
  final GetListStatusQuos getListStatusQuos = GetIt.instance.get<GetListStatusQuos>();
  final GetListUseRightType getListUseRightType = GetIt.instance.get<GetListUseRightType>();

  final UpdateLegalDocsListingUseCase updateUseCase =
      GetIt.instance.get<UpdateLegalDocsListingUseCase>();

  List<StatusQuos>? listStatus;
  List<HomeDirection>? listData;

  LegalDocsBloc() : super(LegalDocsStateInitial()) {
    on<LoadQuoEvent>(_getListQuo);
    on<UpdateLegalDocsEvent>(_updateRequest);
  }

  Future<FutureOr<void>> _getListQuo(LegalDocsEvent e, Emitter<BaseLegalDocsState> emit) async {
    final list = await Future.wait([getListStatusQuos.getList(), getListUseRightType.getList()]);
    if (list.isNotEmpty) {
      final ok = list[0].fold(
        (l) {
          emit(LegalDocsStateLoading());
          return false;
        },
        (r) {
          listStatus = r?.cast<StatusQuos>();
          return true;
        },
      );
      if (ok) {
        list[1].fold(
          (l) => emit(LegalDocsStateLoading()),
          (r) {
            listData = r?.cast<HomeDirection>();
            emit(LegalDocsStateSuccess(false));
          },
        );
      }
    }
  }

  Future<FutureOr<void>> _updateRequest(
      UpdateLegalDocsEvent e, Emitter<BaseLegalDocsState> emit) async {
    Util.showLoading();
    final result = await updateUseCase.update(
      e.id,
      e.priceForStatusQuo,
      e.statusQuoId,
      e.useRightTypeId,
    );
    Util.hideLoading();
    result.fold(
      (l) => emit(LegalDocsStateInitial()),
      (r) {
        emit(LegalDocsStateSuccess(true));
      },
    );
  }
}
