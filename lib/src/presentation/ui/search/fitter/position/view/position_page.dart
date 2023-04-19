import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';

import '../position.dart';
import 'position_view.dart';

class PositionPage extends StatelessWidget {
  const PositionPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    return BlocProvider(
      create: (context) => PositionBloc()..add(LoadPositionEvent(parentBloc.categorySearchRequest.propertyPosition)),
      child: const PositionView(),
    );
  }
}
