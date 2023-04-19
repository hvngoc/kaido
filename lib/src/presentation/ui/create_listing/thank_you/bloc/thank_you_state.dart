import 'package:propzy_home/src/domain/model/category_home_listing.dart';

abstract class ThankYouState {}

class ThankYouInitial extends ThankYouState {}

class ThankYouLoading extends ThankYouState {}

class ThankYouSuccess extends ThankYouState {
  final List<CategoryHomeListing>? list;

  ThankYouSuccess({this.list});
}
