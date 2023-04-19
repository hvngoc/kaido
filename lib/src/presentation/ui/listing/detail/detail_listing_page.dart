

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/bloc/detail_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/bloc/detail_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/detail_listing_view.dart';


class DetailListingPage extends StatelessWidget {
  final int listingId;

  const DetailListingPage({Key? key, required this.listingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => DetailListingBloc()..add(GetListingDetailEvent(listingId: listingId)),
    child:  DetailListingView(listingId: listingId),);
  }
}



