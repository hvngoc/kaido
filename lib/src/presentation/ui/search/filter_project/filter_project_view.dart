import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/bloc/search_filter_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/fitter/property/bloc/property_bloc.dart';
import 'package:propzy_home/src/presentation/view/label_text.dart';
import 'package:propzy_home/src/util/constants.dart';
import '../fitter/property/view/property_view.dart';
import 'filter_project_input_view.dart';
import 'filter_project_model.dart';
import 'filter_project_select_view.dart';
import 'filter_project_input_price_view.dart';

class FilterProjectView extends StatefulWidget {
  const FilterProjectView({Key? key, this.defaultStatusIds}) : super(key: key);

  final List<int>? defaultStatusIds;

  @override
  State<FilterProjectView> createState() => FilterProjectViewState();
}

class FilterProjectViewState extends State<FilterProjectView> {

  static final _filterPriceInput = new GlobalKey<FilterProjectInputPriceViewState>();
  static final _filterYearInput = new GlobalKey<FilterProjectInputViewState>();
  final List<FilterSelectionType> listStatus = FilterSelectionType.listStatus;

  void resetTextField() {
    if (this.mounted) {
      _filterYearInput.currentState?.resetFilter();
      _filterPriceInput.currentState?.resetInput();

      setState(() {
        listStatus[0].isSelected = true;
        listStatus[1].isSelected = false;
        listStatus[2].isSelected = false;
      });
    }
  }

  @override
  void initState() {
    final statusIdsList = widget.defaultStatusIds ?? [];
    if (statusIdsList.length == 1 &&
        (statusIdsList.first == Constants.CATEGORY_FILTER_STATUS_SOON ||
            statusIdsList.first == Constants.CATEGORY_FILTER_STATUS_COMPLETE)
    ) {
      if (statusIdsList.first == Constants.CATEGORY_FILTER_STATUS_SOON) {
        listStatus[1].isSelected = true;
      } else {
        listStatus[2].isSelected = true;
      }
    } else {
      listStatus[0].isSelected = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final parentBloc = context.read<SearchFilterBloc>();
    return BlocProvider(
      create: (context) => PropertyBloc()
        ..add(LoadPropertyEvent(parentBloc.categorySearchRequest.listingTypeId,
            CategoryType.PROJECT, propertyType: parentBloc.categorySearchRequest.propertyTypeIds)),
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 8,
          left: 16,
          right: 16,
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelText(
                  label: 'Loại giao dịch',
                ),
                SizedBox(
                  height: 16,
                ),
                BlocBuilder<PropertyBloc, PropertyState>(
                  builder: (context, state) {
                    final bloc = context.read<PropertyBloc>();
                    return FilterSelectionView(
                      listItems: FilterSelectionType.listListingTypes,
                      currentSelected: parentBloc.categorySearchRequest.listingTypeId,
                      onClickHandler: (int id) {
                        parentBloc.categorySearchRequest.resetFilter();
                        resetTextField();
                        bloc.add(LoadPropertyEvent(id, CategoryType.PROJECT, propertyType: null));
                        parentBloc.search(isSearchProject: true, listingTypeId: id);
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                LabelText(
                  label: 'Loại hình BĐS',
                ),
                PropertyView(),
                SizedBox(
                  height: 16,
                ),
                LabelText(
                  label: 'Giá',
                ),
                FilterProjectInputPriceView(
                  key: _filterPriceInput,
                  minPrice: parentBloc.categorySearchRequest.minPrice,
                  maxPrice: parentBloc.categorySearchRequest.maxPrice,
                  onEndEditing: (fromText, toText) {
                    final minPrice = fromText.length == 0
                        ? -1.0
                        : double.tryParse(fromText.replaceAll('.', ''));
                    final maxPrice = toText.length == 0
                        ? -1.0
                        : double.tryParse(toText.replaceAll('.', ''));
                    parentBloc.search(isSearchProject: true,
                        minPrice: minPrice, maxPrice: maxPrice);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: LabelText(
                    label: 'Trạng thái',
                  ),
                ),
                FilterSelectionStatusView(
                  listItems: listStatus,
                  onClickHandler: (int id) {
                    setState(() {
                      for (var i = 0; i < listStatus.length; i++) {
                        if (listStatus[i].id == id) {
                          listStatus[i].isSelected = true;
                        } else {
                          listStatus[i].isSelected = false;
                        }
                      }
                    });
                    final statusIds = parentBloc.categorySearchRequest.statusIds ?? [];
                    if (statusIds.length == 1) {
                      if (statusIds[0] == id) {
                        return;
                      }
                      if (id == 0) {
                        parentBloc.search(isSearchProject: true, statusIds: []);
                        return;
                      }
                    }
                    parentBloc.search(isSearchProject: true, statusIds: [id]);
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: LabelText(
                    label: 'Năm bàn giao',
                  ),
                ),
                FilterProjectInputView(
                  key: _filterYearInput,
                  fromText: parentBloc.categorySearchRequest.minYear?.toDouble(),
                  toText: parentBloc.categorySearchRequest.maxYear?.toDouble(),
                  fromPlaceHolder: 'Từ năm',
                  toPlaceHolder: 'Đến năm',
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  onEndEditing: (fromText, toText) {
                    final minYear =
                        fromText.length == 0 ? -1 : int.tryParse(fromText);
                    final maxYear =
                        toText.length == 0 ? -1 : int.tryParse(toText);
                    parentBloc.search(isSearchProject: true,
                        minYear: minYear, maxYear: maxYear);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

