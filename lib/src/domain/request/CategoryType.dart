class CategoryType {
  final int type;
  final String slug;

  CategoryType(this.type, this.slug);

  static final CategoryType BUY = CategoryType(1, "mua");
  static final CategoryType RENT = CategoryType(2, "thue");
  static final CategoryType PROJECT = CategoryType(99, "du-an");

  static CategoryType fromValue(int value) {
    if (value == 1) {
      return BUY;
    } else if (value == 2) {
      return RENT;
    } else {
      return PROJECT;
    }
  }
}
