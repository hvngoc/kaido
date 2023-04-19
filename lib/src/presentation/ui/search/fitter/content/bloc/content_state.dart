part of 'content_bloc.dart';

class ContentState {
  const ContentState();
}

class ContentInitial extends ContentState {}

class ContentError extends ContentState {}

class ContentLoaded extends ContentState {
  ContentLoaded({this.data});

  final List<Content?>? data;

  bool isCheckedAll() =>
      (data?.any((element) => element?.isSelected == false)) == false ? true : false;

  ContentLoaded copyWith({List<Content?>? data}) {
    return new ContentLoaded(data: data ?? null);
  }
}
