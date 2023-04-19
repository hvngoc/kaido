import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/local/pref/app_pref.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/model/property_type_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/domain/usecase/filter/get_property_type_list_usecase.dart';
import 'package:propzy_home/src/domain/usecase/search_use_case.dart';
import 'package:propzy_home/src/presentation/ui/search/result/next_visit/next_visit_event.dart';
import 'package:propzy_home/src/presentation/ui/search/result/next_visit/next_visit_state.dart';
import 'package:propzy_home/src/util/log.dart';

class NextVisitBloc extends Bloc<NextVisitEvent, NextVisitState> {
  final PrefHelper prefHelper = GetIt.instance.get<PrefHelper>();
  final propertyUseCase = GetIt.I<GetPropertyTypeListUseCase>();

  final getLocationAutoCompleteUseCase = GetIt.instance.get<GetLocationAutoCompleteUseCase>();
  final saveSearchHistoryUseCase = GetIt.instance.get<SaveSearchHistoryUseCase>();

  NextVisitBloc() : super(NextVisitLoading()) {
    on<NextLocalEvent>(_getNextVisit);
    on<NextSearchEvent>(_getNextSearch);
  }

  FutureOr<void> _getNextVisit(NextLocalEvent event, Emitter<NextVisitState> emit) async {
    int type = await prefHelper.getInt(AppPrefs.lastCategoryTypeKey) ?? CategoryType.BUY.type;
    emit(NextVisitSuccess(type));
  }

  FutureOr<void> _getNextSearch(NextSearchEvent event, Emitter<NextVisitState> emit) async {
    await prefHelper.setInt(AppPrefs.lastCategoryTypeKey, CategoryType.BUY.type);
    //safeLastSearch
    final district = event.districtId;
    if (district != null) {
      try {
        final response = await getLocationAutoCompleteUseCase.getLocationAutoComplete(
          district.name ?? '',
          'mua',
        );
        final SearchAddressSuggestion? suggestion = response.data?.first.list?.first;
        final history = SearchHistory(
            searchId: suggestion?.id,
            searchString: district.name,
            group: "zone",
            resultType: "district",
            metaData: suggestion?.metaData);
        await saveSearchHistoryUseCase.saveSearchHistory(history);
      } catch (e) {
        Log.w("save last search error $e");
      }
    }

    final raw = await propertyUseCase.call(1);
    final List<PropertyType>? properties = raw.fold((l) => [], (r) => r);
    properties?.forEach((element) {
      if (element.id == event.propertyTypeId?.id) {
        element.isChecked = true;
      }
    });
    emit(NextSearchSuccess(
      priceFrom: event.priceFrom,
      priceTo: event.priceTo,
      properties: properties,
    ));
  }
}
