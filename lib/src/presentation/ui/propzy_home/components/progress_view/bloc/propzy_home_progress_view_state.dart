part of 'propzy_home_progress_view_bloc.dart';

abstract class PropzyHomeProgressViewState extends Equatable {
  const PropzyHomeProgressViewState();
}

class PropzyHomeProgressViewInitial extends PropzyHomeProgressViewState {
  @override
  List<Object> get props => [];
}

class GetCompletionPercentageFail extends PropzyHomeProgressViewState {
  @override
  List<Object> get props => [];
}

class GetCompletionPercentageSuccess extends PropzyHomeProgressViewState {
  final double totalPercent;

  GetCompletionPercentageSuccess(this.totalPercent);

  @override
  List<Object> get props => [totalPercent];
}


