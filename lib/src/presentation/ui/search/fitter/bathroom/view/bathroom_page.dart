import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';

import '../bathroom.dart';
import 'bathroom_view.dart';

class BathroomPage extends StatelessWidget {
  const BathroomPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    return BlocProvider(
      create: (context) => BathroomBloc()..add(LoadBathRoomEvent(parentBloc.categorySearchRequest.bathrooms)),
      child: const BathroomView(),
    );
  }
}
