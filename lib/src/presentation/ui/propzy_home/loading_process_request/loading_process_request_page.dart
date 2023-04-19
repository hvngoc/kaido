import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/loading_process_request/bloc/loading_process_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/loading_process_request/loading_process_request.dart';

class LoadingProcessRequestPage extends StatelessWidget {
  const LoadingProcessRequestPage({
    Key? key,
    required this.offerId,
  }) : super(key: key);

  final int offerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingProcessBloc(),
      child: LoadingProcessRequest(offerId: offerId),
    );
  }
}
