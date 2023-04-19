import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/process_view/bloc/propzy_home_process_view_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/process_view/propzy_home_process_view.dart';

class PropzyHomeProcessPage extends StatelessWidget {
  const PropzyHomeProcessPage({
    Key? key,
    required this.offerId,
  }) : super(key: key);

  final int offerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      PropzyHomeProcessViewBloc()
        ..add(GetProcessOfferEvent(offerId)),
      child: BlocBuilder<PropzyHomeProcessViewBloc, PropzyHomeProcessViewState>(
        builder: (context, state) {
          if (state is GetProcessOfferSuccess) {
            return PropzyHomeProcessView(listProcess: state.listProcess);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
