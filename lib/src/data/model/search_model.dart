import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class SearchGroupSuggestion {
  String? group;
  List<SearchAddressSuggestion>? list;

  SearchGroupSuggestion({this.group, this.list});

  factory SearchGroupSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SearchGroupSuggestionFromJson(json);
}

class SearchGroupType {
  final String type;

  SearchGroupType(this.type);

  static final SearchGroupType ZONE = SearchGroupType("zone");
  static final SearchGroupType STREET = SearchGroupType("street");
  static final SearchGroupType PROJECT = SearchGroupType("project");
  static final SearchGroupType PROPZY_HOME = SearchGroupType("propzyHome");
}

class SearchResultType {
  final String type;

  SearchResultType(this.type);

  static final SearchResultType CITY = SearchResultType("city");
  static final SearchResultType DISTRICT = SearchResultType("district");
  static final SearchResultType WARD = SearchResultType("ward");
  static final SearchResultType STREET = SearchResultType("street");
}

@JsonSerializable(createToJson: false, checked: true)
class SearchAddressSuggestion {
  // zone and street
  dynamic id;
  String? display;
  String? resultType;
  String? group;
  SearchMetaData? metaData;
  String? name;
  String? subName;

  // propzy home
  String? address;
  double? price;
  double? priceVND;
  String? formatPriceVnd;
  String? slug;

  // project
  String? projectName;

  SearchAddressSuggestion(
      {this.id,
      this.display,
      this.resultType,
      this.group,
      this.metaData,
      this.name,
      this.subName,
      this.address,
      this.price,
      this.priceVND,
      this.formatPriceVnd,
      this.projectName});

  factory SearchAddressSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SearchAddressSuggestionFromJson(json);
}

@JsonSerializable(createToJson: true, checked: true)
class SearchHistory {
  dynamic searchId;
  String? searchString;
  String? resultType;
  String? group;
  SearchMetaData? metaData;
  String? createdAt;
  bool? isFakeLocation;

  double? lat;
  double? lng;
  bool? isUseMyLocation = false;
  bool? isFakeButtonPlus = false;
  bool? isGroupItem = false;
  int? totalCount;

  SearchHistory(
      {this.searchId,
      this.searchString,
      this.resultType,
      this.group,
      this.metaData,
      this.createdAt,
      this.isFakeLocation,
      this.lat,
      this.lng,
      this.isUseMyLocation,
      this.isGroupItem,
      this.totalCount});


  static SearchHistory getDefaultSearch() {
    SearchHistory searchItemView = new SearchHistory();
    searchItemView.searchId = "hcm";
    searchItemView.resultType = SearchResultType.CITY.type;
    searchItemView.searchString = "Hồ Chí Minh";
    searchItemView.metaData = SearchMetaData()
      ..cityId = 1;
    return searchItemView;
  }

  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryToJson(this);
}

@JsonSerializable(createToJson: true, checked: true)
class SearchMetaData {
  int? cityId;
  String? cityName;
  String? citySlug;
  int? districtId;
  String? districtName;
  String? districtSlug;
  int? wardId;
  String? wardName;
  String? wardSlug;
  int? streetId;
  String? streetName;
  String? streetSlug;

  SearchMetaData(
      {this.cityId,
      this.cityName,
      this.citySlug,
      this.districtId,
      this.districtName,
      this.districtSlug,
      this.wardId,
      this.wardName,
      this.wardSlug,
      this.streetId,
      this.streetName,
      this.streetSlug});

  factory SearchMetaData.fromJson(Map<String, dynamic> json) =>
      _$SearchMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchMetaDataToJson(this);
}

/*@JsonSerializable(createToJson: true, checked: true)
class SearchItemView {
  dynamic searchId;
  double? lat;
  double? lng;
  String? resultType;
  SearchMetaData? metaData;
  String? display;
  bool isUseMyLocation = false;
  bool isFakeButtonPlus = false;
  bool isGroupItem = false;
  int? totalCount;
  String? searchString;
  String? group;
  String? createdAt;
  bool? isFakeLocation;

  SearchItemView(
      {this.searchId,
      this.lat,
      this.lng,
      this.resultType,
      this.metaData,
      this.display,
      this.totalCount,
      this.isUseMyLocation = false,
      this.isFakeButtonPlus = false,
      this.isGroupItem = false});

  static SearchItemView getDefaultSearch() {
    SearchItemView searchItemView = new SearchItemView();
    searchItemView.searchId = "hcm";
    searchItemView.resultType = SearchResultType.CITY.type;
    searchItemView.display = "Hồ Chí Minh";
    searchItemView.metaData = SearchMetaData()..cityId = 1;
    return searchItemView;
  }

  factory SearchItemView.fromJson(Map<String, dynamic> json) =>
      _$SearchItemViewFromJson(json);

  Map<String, dynamic> toJson() => _$SearchItemViewToJson(this);
}*/
