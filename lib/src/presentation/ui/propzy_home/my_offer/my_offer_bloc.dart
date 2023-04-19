import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/my_offer/my_offer_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/my_offer/my_offer_state.dart';

class MyOfferBloc extends Bloc<MyOfferEvent, MyOfferState> {
  MyOfferBloc() : super(InitialMyOfferState());

  final GetListCategoriesOfferUseCase getListCategoriesOfferUseCase =
      GetIt.instance.get<GetListCategoriesOfferUseCase>();

  final GetListOffersByCategoryUseCase getListOffersByCategoryUseCase =
      GetIt.instance.get<GetListOffersByCategoryUseCase>();

  List<PropzyHomeCategoryOffer> listCategories = [];
  int indexSelected = -1;

  @override
  Stream<MyOfferState> mapEventToState(MyOfferEvent event) async* {
    if (event is GetListCategoriesOfferEvent) {
      yield* getListCategoriesOffer();
    } else if (event is GetListOffersByCategoryEvent) {
      yield* getListOffersByCategory(
        event.categoryId,
        event.page,
        event.size,
      );
    } else if (event is SelectItemCategoryEvent) {
      indexSelected = event.index;
      yield SuccessSelectItemCategoryState();
    }
  }

  Stream<MyOfferState> getListCategoriesOffer() async* {
    yield LoadingGetListCategoriesState();
    try {
      BaseResponse<List<PropzyHomeCategoryOffer>> response =
          await getListCategoriesOfferUseCase.getListCategoriesOffer();
      if (response.result == true) {
        if (response.data == null) {
          listCategories = [];
        } else {
          listCategories = response.data!;
          if (indexSelected != -1) {
            for (int i = 0; i < listCategories.length; i++) {
              PropzyHomeCategoryOffer categoryOffer = listCategories[i];
              categoryOffer.isChecked = i == indexSelected;
            }
          } else {
            listCategories[0].isChecked = true;
          }
        }
        yield SuccessGetListCategoriesState();
      } else {
        yield ErrorState(response.message);
      }
    } catch (ex) {
      yield ErrorState(ex.toString());
    }
  }

  Stream<MyOfferState> getListOffersByCategory(
    int categoryId,
    int page,
    int size,
  ) async* {
    if (page == 0) {
      yield LoadingGetListOffersState();
    }
    try {
      BaseResponse<PagingResponse<HomeOfferModel>> response =
          await getListOffersByCategoryUseCase.getListOffersByCategory(
        categoryId,
        page,
        size,
      );
      if (response.result == true) {
        if (response.data?.content == null) {
          yield SuccessGetListOffersState([], response.data?.last);
        } else {
          yield SuccessGetListOffersState(response.data!.content!, response.data?.last);
        }
      } else {
        yield ErrorState(response.message);
      }
    } catch (ex) {
      yield ErrorState(ex.toString());
    }
  }
}
