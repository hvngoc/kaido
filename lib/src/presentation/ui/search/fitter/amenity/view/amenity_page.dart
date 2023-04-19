import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';

import '../amenity.dart';
import 'amenity_view.dart';

class AmenityPage extends StatelessWidget {
  const AmenityPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    return BlocProvider(
      create: (context) => AmenityBloc()..add(LoadAmenityEvent(amenity: parentBloc.categorySearchRequest.amenityIds)),
      child: const AmenityView(),
    );
  }
}
