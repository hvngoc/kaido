part of 'loading_process_bloc.dart';

abstract class LoadingProcessEvent extends Equatable {
  const LoadingProcessEvent();
}

class GetOfferPriceEvent extends LoadingProcessEvent {
  final int offerId;

  GetOfferPriceEvent({
    required this.offerId,
  });

  @override
  List<Object?> get props => [offerId];
}
