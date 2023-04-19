import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:propzy_home/src/data/local/pref/app_pref.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/domain/usecase/search_use_case.dart';
import 'package:propzy_home/src/presentation/ui/search/search/search_event.dart';
import 'package:propzy_home/src/presentation/ui/search/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetLocationAutoCompleteUseCase getLocationAutoCompleteUseCase =
      GetIt.instance.get<GetLocationAutoCompleteUseCase>();
  final SaveSearchHistoryUseCase saveSearchHistoryUseCase =
      GetIt.instance.get<SaveSearchHistoryUseCase>();
  final GetSearchHistoryUseCase getSearchHistoryUseCase =
      GetIt.instance.get<GetSearchHistoryUseCase>();
  final PrefHelper prefHelper = GetIt.instance.get<PrefHelper>();

  SearchBloc() : super(InitializeSearchState());

  List<SearchHistory> listSearchHistory = <SearchHistory>[];
  List<SearchGroupSuggestion> listSearchSuggestion = <SearchGroupSuggestion>[];

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    switch (event.searchEventType) {
      case SearchEventType.initial_state:
        break;
      case SearchEventType.get_location_auto_complete:
        GetLocationAutoCompleteEvent getLocationAutoCompleteEvent =
            event as GetLocationAutoCompleteEvent;
        yield* getLocationAutoComplete(getLocationAutoCompleteEvent);
        break;
      case SearchEventType.get_search_history:
        yield* getSearchHistory();
        break;
      case SearchEventType.save_search_history:
        SaveSearchHistoryEvent saveSearchHistoryEvent = event as SaveSearchHistoryEvent;
        yield* saveSearchHistory(
          saveSearchHistoryEvent.searchHistory,
          saveSearchHistoryEvent.searchItemView,
        );
        break;
      default:
        break;
    }
  }

  Stream<SearchState> getSearchHistory() async* {
    yield LoadingGetSearchHistoryState();
    try {
      String? token = await prefHelper.getAccessToken();
      var isLogin = token?.isNotEmpty == true;
      if (isLogin) {
        List<SearchHistory> listSearchApi = [];
        List<SearchHistory> listSearchLocal = [];
        List<SearchHistory> listSearchTotal = [];
        DateFormat dateFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');

        var values = await Future.wait(
            [getSearchHistoryUseCase.getSearchHistory(), getListSearchHistoryLocal()]);

        if (values.isNotEmpty) {
          if (values[0] is BaseResponse<List<SearchHistory>>) {
            BaseResponse<List<SearchHistory>> response =
                values[0] as BaseResponse<List<SearchHistory>>;
            if (response.result == true) {
              listSearchApi = response.data == null ? <SearchHistory>[] : response.data!;
            }
          }

          if (values.length > 1) {
            if (values[1] is List<SearchHistory>) {
              listSearchLocal = values[1] as List<SearchHistory>;
            }
          }
        }

        if (listSearchApi.isNotEmpty) listSearchTotal.addAll(listSearchApi);
        if (listSearchLocal.isNotEmpty) listSearchTotal.addAll(listSearchTotal);

        listSearchTotal.sort((a, b) {
          int timeA = 0;
          int timeB = 0;
          if (a.createdAt?.isNotEmpty == true) {
            DateTime dateA = dateFormat.parse(a.createdAt.toString());
            timeA = dateA.millisecondsSinceEpoch;
          }
          if (b.createdAt?.isNotEmpty == true) {
            DateTime dateB = dateFormat.parse(b.createdAt.toString());
            timeB = dateB.millisecondsSinceEpoch;
          }

          return timeB.compareTo(timeA);
        });

        if (listSearchTotal.isNotEmpty) {
          listSearchHistory = [];
          for (int i = 0; i < listSearchTotal.length; i++) {
            if (listSearchHistory.length == 5) {
              break;
            }
            listSearchHistory.add(listSearchTotal[i]);
          }
        }

        yield SuccessGetSearchHistoryState(listSearchHistory);
      } else {
        listSearchHistory = await getListSearchHistoryLocal();
      }
      listSearchHistory.insert(0, SearchHistory(isFakeLocation: true));
      yield SuccessGetSearchHistoryState(listSearchHistory);
    } catch (e) {
      yield ErrorGetSearchHistoryState(e.toString());
    }
  }

  Future<List<SearchHistory>> getListSearchHistoryLocal() async {
    List<SearchHistory> listLocal = [];
    var jsonString = await prefHelper.getString(AppPrefs.listSearchHistoryRecentlyKey) ?? "";
    if (jsonString.isEmpty) {
      listLocal = <SearchHistory>[];
    } else {
      listLocal = (json.decode(jsonString) as List).map((i) => SearchHistory.fromJson(i)).toList();
    }

    return listLocal;
  }

  Stream<SearchState> saveSearchHistory(
    SearchHistory searchHistory,
      SearchHistory searchItemView,
  ) async* {
    try {
      String? token = await prefHelper.getAccessToken();
      var isLogin = token?.isNotEmpty == true;
      if (isLogin) {
        BaseResponse<String?> response =
            await saveSearchHistoryUseCase.saveSearchHistory(searchHistory);
        if (response.result == true) {
          yield SuccessSaveSearchHistoryState();
        } else {
          yield ErrorSaveSearchHistoryState(response.message);
        }
      } else {
        prefHelper.setString(
          AppPrefs.lastSearchHistoryKey,
          json.encode(searchItemView),
        );

        var jsonString = await prefHelper.getString(AppPrefs.listSearchHistoryRecentlyKey) ?? "";

        final f = new DateFormat('yyyy-MM-dd HH:mm:ss');
        if (jsonString.isEmpty) {
          listSearchHistory = <SearchHistory>[];
        } else {
          listSearchHistory =
              (json.decode(jsonString) as List).map((i) => SearchHistory.fromJson(i)).toList();
        }

        int indexItemExist = -1;
        for (int i = 0; i < listSearchHistory.length; i++) {
          SearchHistory item = listSearchHistory[i];
          if (item.searchId == searchHistory.searchId) {
            indexItemExist = i;
            break;
          }
        }

        if (indexItemExist == -1) {
          if (listSearchHistory.length == 5) {
            listSearchHistory.removeAt(4);
          }
        } else {
          listSearchHistory.removeAt(indexItemExist);
        }
        searchHistory.createdAt = f.format(DateTime.now());
        listSearchHistory.insert(0, searchHistory);
        await prefHelper.setString(
            AppPrefs.listSearchHistoryRecentlyKey, json.encode(listSearchHistory));
        yield SuccessSaveSearchHistoryState();
      }
    } catch (e) {
      yield ErrorSaveSearchHistoryState(e.toString());
    }
  }

  Stream<SearchState> getLocationAutoComplete(
      GetLocationAutoCompleteEvent getLocationAutoCompleteEvent) async* {
    yield StartGetLocationAutoCompleteState();
    try {
      BaseResponse<List<SearchGroupSuggestion>> response =
          await getLocationAutoCompleteUseCase.getLocationAutoComplete(
              getLocationAutoCompleteEvent.query, getLocationAutoCompleteEvent.type);
      if (response.result == true) {
        listSearchSuggestion = response.data == null ? <SearchGroupSuggestion>[] : response.data!;
        yield SuccessGetLocationAutoCompleteState(listSearchSuggestion);
      } else {
        yield ErrorGetLocationAutoCompleteState(response.message);
      }
    } catch (e) {
      yield ErrorGetLocationAutoCompleteState(e.toString());
    }
  }
}
