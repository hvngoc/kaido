import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/detail_listing_extra.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/util.dart';

import '../../bloc/detail_listing_bloc.dart';

class MainInfoView extends StatefulWidget {
  final Listing? listing;

  const MainInfoView({Key? key, required this.listing}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainInfoViewState();
}

class _MainInfoViewState extends State<MainInfoView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              _renderRowInfoLine1(),
              SizedBox(height: 7),
              _renderRowInfoLine2(),
              SizedBox(height: 7),
              _renderRowInfoLine3(),
              SizedBox(height: 15),
              _renderRowInfoLine4(),
              SizedBox(height: 12),
              _renderRowInfoLine5(),
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(
          height: 1,
          color: HexColor('D7D7D7'),
        ),
      ],
    );
  }

  Widget _renderRowInfoLine1() {
    return Container(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            child: Center(
              child: Text(
                widget.listing?.formatPriceVND ?? "",
                style: TextStyle(
                  color: AppColor.secondaryText,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            height: 24,
            child: Center(
              child: Text(
                widget.listing?.formatUnitPrice ?? "",
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.65),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Spacer(),
          _renderButtonGroup(),
        ],
      ),
    );
  }

  Widget _renderRowInfoLine2() {
    return Container(
      width: double.infinity,
      child: Text(
        widget.listing?.title ?? "",
        style: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 0.8),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _renderRowInfoLine3() {
    return Container(
      width: double.infinity,
      child: Text(
        widget.listing?.formatAddress ?? "",
        style: TextStyle(
          color: AppColor.secondaryText,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _renderRowInfoLine5() {
    return Row(
      children: [
        _renderTagBuyOrRent(),
        _renderTagPriceTrend(),
        _renderTagListingId(),
      ],
    );
  }

  Widget _renderRowInfoLine4() {
    return Container(
      child: Row(
        children: [
          Container(
            child: SvgPicture.asset("assets/images/vector_ic_bedroom.svg"),
            padding: const EdgeInsets.only(right: 8),
          ),
          Text(
            '${widget.listing?.formatBedrooms ?? "--"}',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: AppColor.black_65p),
          ),
          Container(
            child: SvgPicture.asset("assets/images/vector_ic_bathroom.svg"),
            padding: const EdgeInsets.only(right: 8, left: 20),
          ),
          Text(
            '${widget.listing?.formatBathrooms ?? "--"}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.black_65p,
            ),
          ),
          Container(
            child: SvgPicture.asset("assets/images/vector_ic_area.svg"),
            padding: const EdgeInsets.only(right: 8, left: 20),
          ),
          Text(
            '${widget.listing?.formatSize ?? "--"}',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: AppColor.black_65p),
          ),
          Container(
            child: SvgPicture.asset("assets/images/vector_ic_direction.svg"),
            padding: const EdgeInsets.only(right: 8, left: 20),
          ),
          Flexible(
            child: Text(
              '${widget.listing?.directionName ?? "--"}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400, color: AppColor.black_65p),
            ),
          ),
        ],
      ),
    );
    // return Row(
    //   children: [
    //     _renderItemInfo(
    //       'assets/images/ic_bed_detail_listing.svg',
    //       widget.listing?.formatBedrooms ?? "--",
    //     ),
    //     SizedBox(width: 25),
    //     _renderItemInfo(
    //       'assets/images/ic_bath_detail_listing.svg',
    //       widget.listing?.formatBathrooms ?? "--",
    //     ),
    //     SizedBox(width: 25),
    //     _renderItemInfo(
    //       'assets/images/ic_area_detail_listing.svg',
    //       widget.listing?.formatSize ?? "--",
    //     ),
    //     SizedBox(width: 25),
    //     _renderItemInfo(
    //       'assets/images/ic_direction_detail_listing.svg',
    //       widget.listing?.directionName ?? "--",
    //     ),
    //   ],
    // );
  }

  Widget _renderButtonGroup() {
    final parentBloc = context.read<DetailListingBloc>();
    return Row(
      children: [
        Visibility(
          visible: Util.isUrl(widget.listing?.vrLink),
          child: InkResponse(
            radius: 24,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailListingExtraPage(
                    listing: widget.listing,
                    extraType: DetailListingExtraType.VIEW_3D,
                  ),
                ),
              );
            },
            child: Container(
              height: 30,
              width: 30,
              child: Center(
                child: SvgPicture.asset(
                  "assets/images/ic_3d_view_detail_listing.svg",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        InkResponse(
          radius: 24,
          onTap: () {
            parentBloc.share(widget.listing?.slug);
          },
          child: Container(
            height: 30,
            width: 30,
            child: Center(
              child: SvgPicture.asset(
                "assets/images/ic_share_detail_listing.svg",
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        InkResponse(
          radius: 24,
          onTap: () {},
          child: Container(
            height: 30,
            width: 30,
            child: Center(
              child: SvgPicture.asset(
                "assets/images/ic_unfavorite_detail_listing.svg",
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _renderItemInfo(String path, dynamic value) {
  //   return Container(
  //     height: 24,
  //     child: Row(
  //       mainAxisSize: MainAxisSize.max,
  //       children: [
  //         SvgPicture.asset(
  //           path,
  //           width: 24,
  //           height: 24,
  //         ),
  //         SizedBox(width: 5),
  //         Container(
  //           height: 24,
  //           child: Flexible(
  //             child: Text(
  //               value.toString(),
  //               textAlign: TextAlign.center,
  //               overflow: TextOverflow.ellipsis,
  //               maxLines: 1,
  //               style: TextStyle(
  //                 color: Color.fromRGBO(0, 0, 0, 0.65),
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w400,
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _renderTagBuyOrRent() {
    if (widget.listing?.listingTypeId == null) return Container();
    return Row(
      children: [
        Container(
          height: 26,
          padding: EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color.fromRGBO(243, 116, 6, 0.1),
          ),
          child: Center(
            child: Text(
              widget.listing?.listingTypeId == CategoryType.BUY.type ? "Bán" : "Thuê",
              textScaleFactor: 1,
              style: TextStyle(
                color: HexColor('#EF7733'),
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _renderTagPriceTrend() {
    if (widget.listing?.priceTrend == null ||
        widget.listing?.priceTrend != PriceTrendType.DOWN.value) return Container();
    return Row(
      children: [
        Container(
          height: 26,
          padding: EdgeInsets.only(top: 2, bottom: 2, right: 7, left: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: HexColor('#E9F0E6'),
          ),
          child: Center(
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  padding: EdgeInsets.all(4),
                  child: SvgPicture.asset(
                    "assets/images/ic_price_trend_down_detail_listing.svg",
                    width: 8,
                    height: 8,
                  ),
                ),
                Text(
                  widget.listing?.priceTrend == PriceTrendType.DOWN.value
                      ? "Vừa giảm giá"
                      : "Vừa tăng giá",
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: HexColor('#46842F'),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _renderTagListingId() {
    if (widget.listing?.listingId == null) return Container();
    return Container(
      height: 26,
      padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: HexColor('#F4F4F4'),
      ),
      child: Center(
        child: Text(
          "ID:${widget.listing?.listingId}",
          textScaleFactor: 1,
          style: TextStyle(
            color: AppColor.blackDefault,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Future<void> share(String? url) async {
    await FlutterShare.share(linkUrl: "https://propzy.vn/", title: "url");
    Logger().d("share button");
  }
}
