import 'package:propzy_home/src/domain/model/property_type_model.dart';

abstract class NextVisitState {}

class NextVisitLoading extends NextVisitState {
  NextVisitLoading() : super();
}

class NextVisitSuccess extends NextVisitState {
  final int type;

  NextVisitSuccess(this.type) : super();
}

class NextSearchSuccess extends NextVisitState {
  int? priceFrom = null;
  int? priceTo = null;
  List<PropertyType>? properties = null;

  NextSearchSuccess({
    this.priceFrom,
    this.priceTo,
    this.properties,
  }) : super();
}
