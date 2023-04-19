part of 'propzy_home_progress_view_bloc.dart';

abstract class PropzyHomeProgressViewEvent extends Equatable {
  const PropzyHomeProgressViewEvent();
}

class GetCompletionPercentageEvent extends PropzyHomeProgressViewEvent {
  final int offerId;

  GetCompletionPercentageEvent(this.offerId);

  @override
  List<Object?> get props => [offerId];
}
