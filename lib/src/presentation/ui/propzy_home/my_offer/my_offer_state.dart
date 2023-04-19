import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';

abstract class MyOfferState {}

class InitialMyOfferState extends MyOfferState {}

class ErrorState extends MyOfferState {
  final String? message;

  ErrorState(this.message);
}

class LoadingGetListCategoriesState extends MyOfferState {}

class SuccessGetListCategoriesState extends MyOfferState {}

class LoadingGetListOffersState extends MyOfferState {}

class SuccessGetListOffersState extends MyOfferState {
  final List<HomeOfferModel> listOffers;
  final bool? lastPage;

  SuccessGetListOffersState(this.listOffers, this.lastPage);
}

class SuccessSelectItemCategoryState extends MyOfferState {}
