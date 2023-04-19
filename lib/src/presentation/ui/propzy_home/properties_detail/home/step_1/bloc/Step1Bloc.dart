import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_feature.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_1/bloc/Step1Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_1/bloc/Step1State.dart';

class Step1Bloc extends Bloc<Step1Event, Step1State> {
  final GetListParentHouseUseCase useCase = GetIt.instance.get<GetListParentHouseUseCase>();

  List<HomeFeature>? listData;

  Step1Bloc() : super(Step1Loading()) {
    on<Step1Event>(_getListTexture);
  }

  FutureOr<void> _getListTexture(Step1Event event, Emitter<Step1State> emit) async {
    final response = await useCase.call(null);
    response.fold(
      (l) => emit(Step1Loading()),
      (r) {
        listData = r;
        emit(Step1Success());
      },
    );
  }

  bool isSelected() {
    if (listData == null) {
      return false;
    }
    return listData!.any((element) => element.isChecked == true);
  }

  void clearOtherOption(HomeFeature option) {
    final checked = option.isChecked;
    if (checked) {
      listData?.forEach((element) {
        element.isChecked = false;
        element.chill?.forEach((child) {
          child.isChecked = false;
        });
      });
      option.isChecked = checked;
    } else {
      listData?.forEach((element) {
        element.isChecked = false;
        element.chill?.forEach((child) {
          child.isChecked = false;
        });
      });
    }
  }

  List<int?> collectIds() {
    final feature = listData?.firstWhere((e) => e.isChecked == true);
    final children = feature?.chill?.where((e) => e.isChecked == true).map((e) => e.id);
    final List<int?> result = [];
    result.add(feature!.id!);
    if (children != null) {
      result.addAll(children);
    }
    return result;
  }
}
