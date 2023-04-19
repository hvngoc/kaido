import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

abstract class ChooserState {}

class ChooserLoading extends ChooserState {}

class ChooserSuccess extends ChooserState {
  final List<ChooserData> listData;

  ChooserSuccess(this.listData);
}

class ChooserEmpty extends ChooserState {}
