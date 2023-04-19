part of 'content_bloc.dart';

abstract class ContentEvent {
  const ContentEvent();
}

class LoadContentEvent extends ContentEvent {
  const LoadContentEvent(this.currentItemSelected);

  final Content? currentItemSelected;
}

class CheckItemContentEvent extends ContentEvent {
  const CheckItemContentEvent({this.item, required this.index});

  final Content? item;
  final int index;
}

class ResetContent extends ContentEvent {}