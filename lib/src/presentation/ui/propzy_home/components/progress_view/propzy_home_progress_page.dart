import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/bloc/propzy_home_progress_view_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/propzy_home_progress_view.dart';

class PropzyHomeProgressPage extends StatefulWidget {
  PropzyHomeProgressPage({
    Key? key,
    required this.offerId,
  }) : super(key: key);

  final int offerId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PropzyHomeProgressPageState(offerId: offerId);
  }
}

class PropzyHomeProgressPageState extends State<PropzyHomeProgressPage> {
  PropzyHomeProgressPageState({required this.offerId});

  final int offerId;
  final PropzyHomeProgressViewBloc _propzyHomeProgressViewBloc =
      GetIt.I.get<PropzyHomeProgressViewBloc>();

  @override
  void initState() {
    super.initState();
    _propzyHomeProgressViewBloc.add(GetCompletionPercentageEvent(offerId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _propzyHomeProgressViewBloc,
      listener: (context, state) {
        setState(() {});
      },
      builder: (context, state) {
        if (state is GetCompletionPercentageSuccess) {
          return PropzyHomeProgressView(totalPercent: state.totalPercent);
        } else {
          final double totalPercent = (_propzyHomeProgressViewBloc.offerId ?? 0) == widget.offerId
              ? (_propzyHomeProgressViewBloc.totalPercent ?? 0)
              : 0;
          return PropzyHomeProgressView(totalPercent: totalPercent);
        }
      },
    );
  }
}
