part of 'propzy_home_process_view_bloc.dart';

abstract class PropzyHomeProcessViewState extends Equatable {
  const PropzyHomeProcessViewState();
}

class PropzyHomeProcessViewInitial extends PropzyHomeProcessViewState {
  @override
  List<Object> get props => [];
}

class GetProcessOfferFail extends PropzyHomeProcessViewState {
  @override
  List<Object?> get props => [];
}

class GetProcessOfferSuccess extends PropzyHomeProcessViewState {
  final List<PropzyHomeProcessModel> listProcess;

  GetProcessOfferSuccess(this.listProcess);

  @override
  List<Object?> get props => [listProcess];
}