import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';

import '../content.dart';
import 'content_view.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();

    return BlocProvider(
      create: (context) => ContentBloc()..add(LoadContentEvent(parentBloc.categorySearchRequest.contentId)),
      child: const ContentView(),
    );
  }
}
