part of 'propzy_home_process_view_bloc.dart';

abstract class PropzyHomeProcessViewEvent extends Equatable {
  const PropzyHomeProcessViewEvent();
}

class GetProcessOfferEvent extends PropzyHomeProcessViewEvent {
  final int offerId;

  GetProcessOfferEvent(this.offerId);

  @override
  List<Object?> get props => [offerId];
}
