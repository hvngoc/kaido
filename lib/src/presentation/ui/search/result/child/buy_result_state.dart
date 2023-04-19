import 'package:flutter/material.dart';
import 'package:propzy_home/src/domain/model/category_home_listing.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/bloc_home.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/result/child/base_result_state.dart';
import 'package:propzy_home/src/presentation/ui/search/result/empty/buy_empty_search.dart';
import 'package:propzy_home/src/presentation/view/card_view_search_home.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';

class SearchBuyState extends BaseSearchResultState<CategoryHomeListing> {
  @override
  String getSortTile(int? totalItem) => 'Có $totalItem BĐS bán';

  @override
  BaseResultBloc<CategoryHomeListing> homeResultBloc = ResultHomeBloc();

  @override
  Widget buildEmptyView() => BuyEmptySearchView(parentBloc: homeResultBloc);

  @override
  Widget buildCardItemSearch(CategoryHomeListing? home) {
    if (home == null) {
      return Container(
          alignment: Alignment.center,
          child: const LoadingView(
            width: 160,
            height: 80,
          ));
    }

    List<String>? listImages =
        (home.useDefaultPhoto == true) ? null : home.thumbnails?.map((e) => e.link!).toList();
    bool isPropzyHome = home.labelCode == "PROPZY_HOME";
    bool isPriceDown = home.priceTrend == "DOWN";
    String? labelName = isPropzyHome ? null : home.labelName;
    String? bedrooms = home.bedrooms == null ? "--" : home.bedrooms?.toString();
    String? bathrooms = home.bathrooms == null ? "--" : home.bathrooms?.toString();
    String? formattedSize = home.formattedSize == null ? "--" : home.formattedSize?.toString();
    String? directionName = home.directionName == null ? "--" : home.directionName?.toString();
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 2),
      child: CardViewSearchHome(
        listingId: home.id,
        isPropzyHome: isPropzyHome,
        isPriceDown: isPriceDown,
        labelName: labelName,
        tradedStatus: home.tradedStatus,
        formattedPriceVnd: home.formattedPriceVnd,
        formattedUnitPrice: home.formattedUnitPrice,
        title: home.title,
        address: home.getAddress(),
        isFavorite: true,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        formattedSize: formattedSize,
        directionName: directionName,
        projectName: home.projectName,
        projectId: home.projectId,
        listImages: listImages,
      ),
    );
  }
}
