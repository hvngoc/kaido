import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';

import '../bedroom.dart';
import 'bedroom_view.dart';

class BedroomPage extends StatelessWidget {
  const BedroomPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    return BlocProvider(
      create: (context) => BedroomBloc()..add(LoadBedRoomEvent(parentBloc.categorySearchRequest.bedrooms)),
      child: const BedroomView(),
    );
  }
}
