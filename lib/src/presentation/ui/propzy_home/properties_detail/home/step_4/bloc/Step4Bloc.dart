import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_4/bloc/Step4Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_4/bloc/Step4State.dart';

class Step4Bloc extends Bloc<Step4Event, Step4State> {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

  Step4Bloc() : super(Step4State()) {}
}
