import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';

import '../direction.dart';
import 'direction_view.dart';

class DirectionPage extends StatelessWidget {
  const DirectionPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    return BlocProvider(
      create: (context) => DirectionBloc()..add(LoadDirectionEvent(direction: parentBloc.categorySearchRequest.directionIds)),
      child: const DirectionView(),
    );
  }
}
