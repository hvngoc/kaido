import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/usecase/base_usecase.dart';

import '../../../../../../domain/model/common_model_1.dart';
import '../../../../../../domain/usecase/filter/get_content_list_usecase.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  ContentBloc() : super(ContentInitial()) {
    on<LoadContentEvent>(_getContentList);
    on<CheckItemContentEvent>(_checkItem);
    on<ResetContent>(_resetContent);
  }

  final getContentListUseCase = GetIt.I<GetContentListUseCase>();

  FutureOr<void> _getContentList(
      LoadContentEvent event, Emitter<ContentState> emit) async {
    final result = await getContentListUseCase.call(NoParams());
    result.fold(
      (l) => emit(ContentError()),
      (contentList) {
        final Content? currentItemSelected = event.currentItemSelected;
        if(currentItemSelected?.id != null){
          contentList?.firstWhere((element) => element.id == currentItemSelected?.id).isSelected = true;
        }
        else{
          contentList?.first.isSelected = true;
        }
       emit(ContentLoaded(data: contentList));
      }
    );
  }

  FutureOr<void> _checkItem(CheckItemContentEvent event, Emitter<ContentState> emit) {
    if (state is ContentLoaded) {
      final currentListData = (state as ContentLoaded).data;
      int index = currentListData?.indexWhere((element) => element?.isSelected == true) ?? 0;

      if (index != event.index) {
        List<Content?>? previousData =
        (state as ContentLoaded).data?.map((e) => Content.clone(e)).toList();
        previousData?.forEach((element) {
          element?.isSelected = event.item?.id == element.id;
        });

        emit(ContentLoaded().copyWith(data: previousData));
      }
    }
  }

  FutureOr<void> _resetContent(ResetContent event, Emitter<ContentState> emit) {
    if (state is ContentLoaded) {
      final currentListData = (state as ContentLoaded).data;
        currentListData?.firstWhere((element) => element?.isSelected == true)?.isSelected = false;
        currentListData?.first?.isSelected = true;
        emit(ContentLoaded().copyWith(data: currentListData));
      }
    }
}
