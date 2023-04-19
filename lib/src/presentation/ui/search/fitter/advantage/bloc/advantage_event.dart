part of 'advantage_bloc.dart';

abstract class AdvantageEvent extends Equatable {
  const AdvantageEvent();

  @override
  List<Object> get props => [];
}

class LoadAdvantageEvent extends AdvantageEvent {
  const LoadAdvantageEvent({this.advantage});

  final List<Advantage?>? advantage;
}

class CheckAllAdvantageEvent extends AdvantageEvent {}

class CheckItemAdvantageEvent extends AdvantageEvent {
  const CheckItemAdvantageEvent({this.item, required this.index});

  final Advantage? item;
  final int index;
}

class ResetAdvantageEvent extends AdvantageEvent {}
