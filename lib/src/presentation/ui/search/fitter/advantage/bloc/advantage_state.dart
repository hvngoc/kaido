part of 'advantage_bloc.dart';

class AdvantageState {
  const AdvantageState();
}

class AdvantageInitial extends AdvantageState {}

class AdvantageError extends AdvantageState {}

class AdvantageLoaded extends AdvantageState {
  AdvantageLoaded({this.data});

  final List<Advantage?>? data;

  bool isCheckedAll() =>
      (data?.every((element) => element?.isChecked == true)) == true ? true : false;

  AdvantageLoaded copyWith({List<Advantage?>? data}) {
    return new AdvantageLoaded(data: data ?? null);
  }
}
