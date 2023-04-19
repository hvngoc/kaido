class SortBy {
  SortBy(this.key, this.sortBy, this.sortDirection, this.name);

  final int key;
  final String? sortBy;
  final String? sortDirection;
  final String name;

  static final SortBy DEFAULT = SortBy(1, null, null, 'Đề xuất phù hợp');
  static final SortBy NEWEST = SortBy(2, 'date', 'DESC', 'Mới nhất');
  static final SortBy PRICE_UP = SortBy(3, 'price', 'ASC', 'Giá tăng dần');
  static final SortBy PRICE_DOWN = SortBy(4, 'price', 'DESC', 'Giá giảm dần');
  static final SortBy SIZE_UP = SortBy(5, 'size', 'ASC', 'Diện tích tăng dần');
  static final SortBy SIZE_DOWN = SortBy(6, 'size', 'DESC', 'Diện tích giảm dần');
  static final SortBy YEAR_UP = SortBy(7, 'yearBuilt', 'ASC', 'Năm xây dựng tăng dần');
  static final SortBy YEAR_DOWN = SortBy(8, 'yearBuilt', 'DESC', 'Năm xây dựng giảm dần');
}
