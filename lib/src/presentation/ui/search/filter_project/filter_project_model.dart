import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/constants.dart';

class FilterSelectionType {
  final int id;
  final String name;
  bool isSelected;

  FilterSelectionType({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  static List<FilterSelectionType> listListingTypes = [
    FilterSelectionType(id: 1, name: 'Mua'),
    FilterSelectionType(id: 2, name: 'Thuê')
  ];

  static List<FilterSelectionType> listStatus = [
    FilterSelectionType(id: Constants.CATEGORY_FILTER_STATUS_ALL, name: 'Tất cả'),
    FilterSelectionType(id: Constants.CATEGORY_FILTER_STATUS_SOON, name: Constants.CATEGORY_NAME_SOON),
    FilterSelectionType(id: Constants.CATEGORY_FILTER_STATUS_COMPLETE, name: Constants.CATEGORY_NAME_COMPLETE)
  ];
}
