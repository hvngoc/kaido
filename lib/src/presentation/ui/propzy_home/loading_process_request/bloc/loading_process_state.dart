part of 'loading_process_bloc.dart';

class LoadingProcessState extends Equatable {
  const LoadingProcessState();

  @override
  List<Object> get props => [];
}

class LoadingProcessInitial extends LoadingProcessState {}

class GetOfferStatusError extends LoadingProcessState {}

class GetOfferStatusSuccess extends LoadingProcessState {
  final String status;

  GetOfferStatusSuccess(this.status);

  @override
  List<Object> get props => [status];
}