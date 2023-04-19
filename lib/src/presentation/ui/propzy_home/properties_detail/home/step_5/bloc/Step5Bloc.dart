import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_5/bloc/Step5Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_5/bloc/Step5State.dart';

class Step5Bloc extends Bloc<Step5Event, Step5State> {
  Step5Bloc() : super(Step5State()) {}
}
