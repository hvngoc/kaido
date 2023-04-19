import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/usecase/get_chooser_list_use_case.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_event.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/bloc/choose_state.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/util/log.dart';

abstract class ChooserBloc<T> extends Bloc<ChooserEvent, ChooserState> {
  abstract GetChooserListUseCase<T> useCase;
  List<ChooserData> listRaw = [];
  bool canAddMoreData = false;

  ChooserBloc() : super(ChooserLoading());

  ChooserData convertResponse(T item);

  @override
  Stream<ChooserState> mapEventToState(ChooserEvent event) async* {
    if (event is LoadDataEvent) {
      yield* getListData(event.value);
    } else if (event is SearchNameEvent) {
      yield* searchText(event.name);
    } else {
      super.onEvent(event);
    }
  }

  Stream<ChooserState> searchText(String? name) async* {
    if (name == null || name.isEmpty) {
      yield ChooserSuccess(listRaw);
    } else if (listRaw.isEmpty) {
      if (canAddMoreData) {
        List<ChooserData> res = [ChooserData(null, name, isAddMore: true)];
        yield ChooserSuccess(res);
      } else {
        yield ChooserEmpty();
      }
    } else {
      List<ChooserData> res = listRaw
          .where((e) => e.unsignedName.toLowerCase().contains(name.toLowerCase()))
          .toList();
      if (res.isEmpty) {
        if (canAddMoreData) {
          res = [ChooserData(null, name, isAddMore: true)];
          yield ChooserSuccess(res);
        } else {
          yield ChooserEmpty();
        }
      } else {
        if (canAddMoreData) {
          res.add(ChooserData(null, name, isAddMore: true));
        }
        yield ChooserSuccess(res);
      }
    }
  }

  Stream<ChooserState> getListData(dynamic value) async* {
    try {
      BaseResponse<List<T>> response = await useCase.getData(value);

      if (response.result == true) {
        if (response.data == null || response.data!.isEmpty == true) {
          yield ChooserEmpty();
        } else {
          listRaw = response.data!.map((e) => convertResponse(e)).toList();
          yield ChooserSuccess(listRaw);
        }
      } else {
        Log.w("loading-error-result: ${response.message}");
        yield ChooserEmpty();
      }
    } catch (e) {
      Log.e("loading-result: " + e.toString());
      yield ChooserEmpty();
    }
  }
}
