import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/property/bloc/property_bloc.dart';

import 'property_view.dart';

class PropertyPage extends StatelessWidget {
  const PropertyPage({
    Key? key,
    required this.categoryType,
    required this.listingTypeId,
  }) : super(key: key);

  final CategoryType categoryType;
  final int listingTypeId;

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    return BlocProvider(
      create: (_) => PropertyBloc()..add(LoadPropertyEvent(listingTypeId,
          categoryType, propertyType: parentBloc.categorySearchRequest.propertyTypeIds)),
      child: PropertyView(),
    );
  }
}
