abstract class MyOfferEvent {}

class GetListCategoriesOfferEvent extends MyOfferEvent {}

class SelectItemCategoryEvent extends MyOfferEvent {
  final int index;

  SelectItemCategoryEvent(this.index);
}

class GetListOffersByCategoryEvent extends MyOfferEvent {
  final int categoryId;
  final int page;
  final int size;

  GetListOffersByCategoryEvent(this.categoryId, this.page, this.size);
}
