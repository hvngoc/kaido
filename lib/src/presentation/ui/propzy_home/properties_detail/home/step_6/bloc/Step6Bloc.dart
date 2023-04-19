import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_6/bloc/Step6Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_6/bloc/Step6State.dart';

class Step6Bloc extends Bloc<Step6Event, Step6State> {
  final List<int> listYear = [];

  Step6Bloc() : super(Step6State()) {
    final today = DateTime.now();
    final year = today.year;
    for (int i = year; i >= 1990; --i) {
      listYear.add(i);
    }
  }
}
