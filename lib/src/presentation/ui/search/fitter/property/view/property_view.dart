import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_style.dart';
import 'package:propzy_home/src/util/util.dart';

import '../property.dart';

class PropertyView extends StatelessWidget {
  const PropertyView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    final bloc = context.read<PropertyBloc>();
    parentBloc.propertyBloc = bloc;
    return BlocListener<PropertyBloc, PropertyState>(
      listener: (BuildContext context, state) {},
      listenWhen: (previous, current) {
        if (previous is PropertyLoaded && current is PropertyLoaded) {
          var isDiff = previous.data?.map((e) =>
                  {current.data?.map((c) => e?.isChecked != c?.isChecked)}) !=
              null;
          if (isDiff) {
            parentBloc.search(isSearchProject: parentBloc.categorySearchRequest.categoryType == CategoryType.PROJECT ? true : false,
                propertyTypeListSelected: current.data);
          }
        }
        return true;
      },
      child: BlocBuilder<PropertyBloc, PropertyState>(
        builder: (context, state) {
          if (state is PropertyInitial) {
            return Center(
              child: LoadingView(
                width: 100,
                height: 100,
              ),
            );
          }
          if (state is PropertyLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      bloc.add(CheckAllPropertyEvent());
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
        },
      ),
    );
  }

  Widget buildCheckbox(PropertyBloc bloc, PropertyLoaded state, int index) {
    final item = state.data?[index];
    return InkWell(
      onTap: () {
        bloc.add(CheckItemPropertyEvent(
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
