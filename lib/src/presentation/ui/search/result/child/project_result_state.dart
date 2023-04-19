import 'package:flutter/material.dart';
import 'package:propzy_home/src/domain/model/category_home_project.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/bloc_project.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_event.dart';
import 'package:propzy_home/src/presentation/ui/search/result/child/base_result_state.dart';
import 'package:propzy_home/src/presentation/ui/search/result/empty/project_empty_search.dart';
import 'package:propzy_home/src/presentation/ui/search/result/sort_by_home.dart';
import 'package:propzy_home/src/presentation/view/card_view_project_item.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class SearchProjectState extends BaseSearchResultState<CategoryHomeProject> {
  @override
  String getSortTile(int? totalItem) => 'Có $totalItem dự án';

  @override
  BaseResultBloc<CategoryHomeProject> homeResultBloc = ResultProjectBloc();

  @override
  Widget buildEmptyView() => ProjectEmptySearchView(parentBloc: homeResultBloc);

  @override
  Widget buildCardItemSearch(CategoryHomeProject? home) {
    if (home == null) {
      return Container(
        alignment: Alignment.center,
        child: const LoadingView(
          width: 160,
          height: 80,
        ),
      );
    }

    List<String>? listImages = home.thumbnails?.map((e) => e.link!).toList();
    String projectName = home.projectName ?? "";

    var priceFrom = "Giá từ: Đang cập nhật";
    if (home.numberOfLiveListingForSale == 0 && home.numberOfLiveListingForRent == 0) {
      priceFrom = "Giá từ: Đang cập nhật";
    } else {
      if (homeResultBloc.categoryRequest.listingTypeId == CategoryType.BUY.type) {
        if (home.minPriceOfLiveListingSale == home.maxPriceOfLiveListingSale) {
          priceFrom = "Giá chỉ từ ${home.formattedMinPriceOfLiveListingSale}/căn";
        } else {
          priceFrom =
              "Giá từ ${home.formattedMinPriceOfLiveListingSale} - ${home.formattedMaxPriceOfLiveListingSale}/căn";
        }
      } else if (homeResultBloc.categoryRequest.listingTypeId == CategoryType.RENT.type) {
        if (home.minPriceOfLiveListingRent == home.maxPriceOfLiveListingRent) {
          priceFrom = "Giá chỉ từ ${home.formattedMinPriceOfLiveListingRent}/tháng";
        } else {
          priceFrom =
              "Giá từ ${home.formattedMinPriceOfLiveListingRent} - ${home.formattedMaxPriceOfLiveListingRent}/tháng";
        }
      }
    }

    String address = "Địa chỉ: ${home.address}";

    var investor = "Chủ đầu tư: Đang cập nhật";
    if (home.investorName != null) {
      investor =
          "Chủ đầu tư: ${home.investorName?.isEmpty == true ? "Đang cập nhật" : home.investorName}";
    }

    var selling = "Đang bán: ${home.numberOfLiveListingForSale} căn";
    bool isSelling =
        home.numberOfLiveListingForSale != null && home.numberOfLiveListingForSale! > 0;
    var renting = "Cho thuê: ${home.numberOfLiveListingForRent} căn";
    bool isRenting =
        home.numberOfLiveListingForRent != null && home.numberOfLiveListingForRent! > 0;

    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 2),
      child: CardViewProjectItem(
        id: home.id,
        listImages: listImages,
        projectName: projectName,
        priceFrom: priceFrom,
        address: address,
        investor: investor,
        selling: selling,
        isSelling: isSelling,
        renting: renting,
        isRenting: isRenting,
      ),
    );
  }

  @override
  Widget buildSortByView(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                'Sắp xếp dữ liệu',
                style: TextStyle(
                  color: AppColor.blackDefault,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            SortItemChildView(
                text: SortBy.DEFAULT.name,
                isChecked: homeResultBloc.sortBy.key == SortBy.DEFAULT.key,
                onClick: () {
                  homeResultBloc.add(ChangeSortByEvent(SortBy.DEFAULT));
                  Navigator.pop(context);
                }),
            Divider(height: 1, color: AppColor.dividerGray),
            SortItemChildView(
                text: SortBy.YEAR_UP.name,
                isChecked: homeResultBloc.sortBy.key == SortBy.YEAR_UP.key,
                onClick: () {
                  homeResultBloc.add(ChangeSortByEvent(SortBy.YEAR_UP));
                  Navigator.pop(context);
                }),
            Divider(height: 1, color: AppColor.dividerGray),
            SortItemChildView(
                text: SortBy.YEAR_DOWN.name,
                isChecked: homeResultBloc.sortBy.key == SortBy.YEAR_DOWN.key,
                onClick: () {
                  homeResultBloc.add(ChangeSortByEvent(SortBy.YEAR_DOWN));
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
