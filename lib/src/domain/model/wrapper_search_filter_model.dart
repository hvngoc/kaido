import 'package:json_annotation/json_annotation.dart';
import 'package:propzy_home/src/domain/model/common_model_1.dart';
import 'package:propzy_home/src/domain/model/property_type_model.dart';

part 'wrapper_search_filter_model.g.dart';

@JsonSerializable(checked: true)
class WrapperSearchFilterModel {
  WrapperSearchFilterModel({
    this.propertyTypeListSelected,
    this.bedRoomListSelected,
    this.bathRoomListSelected,
    this.positionListSelected,
  });

  List<PropertyType?>? propertyTypeListSelected;
  List<BedRoom?>? bedRoomListSelected;
  List<BathRoom?>? bathRoomListSelected;
  List<Position?>? positionListSelected;

  WrapperSearchFilterModel copyWith({
    List<PropertyType?>? propertyTypeListSelected,
    List<BedRoom?>? bedRoomListSelected,
    List<BathRoom?>? bathRoomListSelected,
    List<Position?>? positionListSelected,
  }) {
    return new WrapperSearchFilterModel(
      propertyTypeListSelected: propertyTypeListSelected ?? null,
      bedRoomListSelected: bedRoomListSelected ?? null,
      bathRoomListSelected: bathRoomListSelected ?? null,
      positionListSelected: positionListSelected ?? null,
    );
  }
}
