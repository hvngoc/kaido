import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';

import '../../../../../../domain/model/common_model_1.dart';
import '../bathroom.dart';

class BathroomView extends StatelessWidget {
  const BathroomView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    final bloc = context.read<BathroomBloc>();
    parentBloc.bathroomBloc = bloc;

    return BlocListener<BathroomBloc, BathroomState>(
      listener: (context, state) {},
      listenWhen: (previous, current) {
        if (previous is BathroomLoaded && current is BathroomLoaded) {
          int? previousIndexSelected = previous.data
              ?.indexWhere((element) => element?.isSelected == true);
          int? currentIndexSelected = current.data
              ?.indexWhere((element) => element?.isSelected == true);
          var isDiff = previousIndexSelected != currentIndexSelected;
          if (isDiff) {
            int index = currentIndexSelected ?? 0;
            parentBloc.search(bathrooms:index == 0 ? BathRoom.ALL : current.data?.elementAt(index));
          }
        }
        return true;
      },
      child: BlocBuilder<BathroomBloc, BathroomState>(
        builder: (context, state) {
          if (state is BathroomInitial) {
            return Center(
              child: LoadingView(
                width: 100,
                height: 100,
              ),
            );
          }
          if (state is BathroomLoaded) {
            final dataList = state.data ?? [];
            return Container(
              margin: EdgeInsets.symmetric(
                vertical: 8,
              ),
              height: 50,
              child: ListView.separated(
                itemCount: dataList.length,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    _buildItem(dataList[index], bloc, index),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 4,
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildItem(BathRoom? item, BathroomBloc bloc, int index) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor:
            item?.isSelected == true ? Colors.transparent : AppColor.grayF4,
        side: BorderSide(
          width: 1.0,
          color:
              item?.isSelected == true ? AppColor.propzyBlue : AppColor.grayF4,
        ),
      ),
      onPressed: () {
        bloc.add(CheckItemBathroomEvent(
          index: index,
          item: item,
        ));
      },
      child: Text(
        '${item?.description}',
        style: TextStyle(
          color: item?.isSelected == true
              ? AppColor.propzyBlue
              : AppColor.blackDefault,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
