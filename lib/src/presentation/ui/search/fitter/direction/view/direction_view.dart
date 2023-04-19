import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_style.dart';
import 'package:propzy_home/src/util/util.dart';

import '../../bloc/search_filter_bloc.dart';
import '../direction.dart';

class DirectionView extends StatelessWidget {
  const DirectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    final bloc = context.read<DirectionBloc>();
    parentBloc.directionBloc = bloc;
    return BlocListener<DirectionBloc, DirectionState>(
        listener: (BuildContext context, state) {},
        listenWhen: (previous, current) {
          if (previous is DirectionLoaded && current is DirectionLoaded) {
            var isDiff = previous.data?.map((e) =>
                    {current.data?.map((c) => e?.isChecked != c?.isChecked)}) !=
                null;
            if (isDiff) {
              parentBloc.search(
                  directionListSelected: current.data);
            }
          }
          return true;
        },
        child: BlocBuilder<DirectionBloc, DirectionState>(
            builder: (context, state) {
          if (state is DirectionInitial) {
            return Center(
              child: LoadingView(
                width: 100,
                height: 100,
              ),
            );
          }
          if (state is DirectionLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      bloc.add(CheckAllDirectionEvent());
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Util.checkboxFilterAll(state.isCheckedAll()),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          state.isCheckedAll()
                              ? "Bỏ chọn tất cả"
                              : "Chọn tất cả",
                          style: BigRevampStyle.checkAllTextStyle,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (2 / .5),
                  ),
                  itemCount: state.data?.length,
                  itemBuilder: (context, index) =>
                      buildCheckbox(bloc, state, index),
                ),
              ],
            );
          }
          return Container();
        }));
  }

  Widget buildCheckbox(DirectionBloc bloc, DirectionLoaded state, int index) {
    final item = state.data?[index];
    return InkWell(
      onTap: () {
        bloc.add(CheckItemDirectionEvent(
          item: item,
          index: index,
        ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 8,
          ),
          SizedBox(
            height: 20,
            width: 20,
            child: Util.checkboxFilter(item?.isChecked),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            width: 111,
            child: Text(
              item?.name ?? '',
              style: BigRevampStyle.checkboxTextStyle,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
