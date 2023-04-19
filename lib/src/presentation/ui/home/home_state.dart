import 'package:propzy_home/src/data/model/force_update_info.dart';
import 'package:propzy_home/src/presentation/ui/home/home_event.dart';

class HomeState {}

class InitialHomeState extends HomeState {}

class ShowDialogForceUpdateState extends HomeState {
  final ForceUpdateInfo? forceUpdateInfo;

  ShowDialogForceUpdateState(this.forceUpdateInfo);
}

class ErrorCheckUpdateVersionState extends HomeState {
  final String? errorMessage;

  ErrorCheckUpdateVersionState(this.errorMessage);
}

class GetInfoStateSuccess extends HomeState {}

class GetInfoStateError extends HomeState {}

class GoToSearchSuccess extends HomeState {
  final GoToSearchEvent? event;

  GoToSearchSuccess({this.event});
}
