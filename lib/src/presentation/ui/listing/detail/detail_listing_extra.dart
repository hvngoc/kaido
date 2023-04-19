import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/image/images_detail_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bloc/detail_listing_bloc.dart';

enum DetailListingExtraType {
  LIST_IMAGE,
  VIEW_3D,
}

class DetailListingExtraPage extends StatefulWidget {
  final Listing? listing;
  final int? currentPositionImage;
  DetailListingExtraType extraType;

  DetailListingExtraPage({
    Key? key,
    required this.listing,
    required this.extraType,
    this.currentPositionImage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailListingExtraState();
}

class _DetailListingExtraState extends State<DetailListingExtraPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        child: Column(
          children: [
            _renderAppBarView(),
            Visibility(
              visible: widget.extraType == DetailListingExtraType.LIST_IMAGE,
              child: ImagesDetailView(
                listing: widget.listing,
                currentPositionImage: widget.currentPositionImage,
              ),
            ),
            Visibility(
              visible: widget.extraType == DetailListingExtraType.VIEW_3D,
              child: Expanded(
                child: WebView(
                  initialUrl: widget.listing?.vrLink.toString(),
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
            ),
            _renderFooterView(),
          ],
        ),
      ),
    );
  }

  Widget _renderAppBarView() {
    return SafeArea(
      bottom: false,
      child: Container(
        height: kToolbarHeight,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkResponse(
              radius: 24,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back,
                  color: HexColor('363636'),
                ),
              ),
            ),
            SizedBox(width: 7),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.listing?.formatPriceVND ?? "",
                      style: TextStyle(
                        color: AppColor.secondaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      widget.listing?.formatAddress ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.65),
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 7),
            _renderButtonGroup(),
          ],
        ),
      ),
    );
  }

  Widget _renderFooterView() {
    WindowPadding viewPadding = window.viewPadding;
    return Container(
      height: 54,
      margin: EdgeInsets.only(
        bottom: Platform.isIOS && viewPadding.bottom > 20 ? kBottomNavigationBarHeight : 20,
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
      ),
      color: Colors.white,
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: HexColor('DBDBDB')),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/images/ic_contact_support.svg",
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: HexColor('DBDBDB')),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/images/ic_call_orange.svg",
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: HexColor('EF7733'),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/ic_schedule_booking_detail_listing.svg",
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Xem nhà ngay",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderButtonGroup() {
    final bloc = DetailListingBloc();
    return Row(
      children: [
        Visibility(
          visible: Util.isUrl(widget.listing?.vrLink),
          child: InkResponse(
            radius: 24,
            onTap: () {
              setState(() {
                widget.extraType = DetailListingExtraType.VIEW_3D;
              });
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
        SizedBox(width: 5),
        InkResponse(
          radius: 24,
          onTap: () {
            bloc.share(widget.listing?.slug);
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
        SizedBox(width: 5),
        InkResponse(
          radius: 24,
          onTap: () {
            Logger().d("share button");
          },
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
}
