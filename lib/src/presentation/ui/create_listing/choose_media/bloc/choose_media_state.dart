part of 'choose_media_bloc.dart';

abstract class ChooseMediaState {}

class ChooseMediaInitial extends ChooseMediaState {}

class ChooseMediaCaptureImageSuccess extends ChooseMediaState {}

class ChooseMediaUploadFilesSuccess extends ChooseMediaState {}

class ChooseMediaDeleteFileSuccess extends ChooseMediaState {}

class ChooseMediaStartTimerState extends ChooseMediaState {}

class ChooseMediaSetDefaultSuccess extends ChooseMediaState {}

class ChooseMediaLoadDataSuccess extends ChooseMediaState {}