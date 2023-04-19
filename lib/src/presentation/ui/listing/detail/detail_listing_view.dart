import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/bloc/detail_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/bloc/detail_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/bloc/detail_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/detail_listing_extra.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/image/image_slider.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/info/detail/detail_info.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/info/main/main_info.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/info/overview/overview_info.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/info/project/project_info.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/info/utilities/utilities_info.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/scroll/scrollable_tab_sync.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/util.dart';

class DetailListingView extends StatefulWidget {
  final int listingId;

  const DetailListingView({Key? key, required this.listingId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailListingState();
}

class _DetailListingState extends State<DetailListingView> {

  Listing? listing = null;
  ListingInteraction? interaction = null;
  bool _isShowAppBar = false;
  List<ItemSync> tabs = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: AppColor.orangeDark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final _detailListingBloc = context.read<DetailListingBloc>();
    tabs = [
      ItemSync(
        null,
        ImageSlider(
          listing: listing,
          onClickItemImage: (selectedIndex) {
            if (listing?.photos?.isNotEmpty == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailListingExtraPage(
                    listing: listing,
                    extraType: DetailListingExtraType.LIST_IMAGE,
                    currentPositionImage: selectedIndex,
                  ),
                ),
              );
            }
          },
        ),
      ),
      ItemSync(
        null,
        MainInfoView(listing: listing),
      ),
      ItemSync(
        "Tổng quan",
        OverviewInfoView(
          listing: listing,
          interaction: interaction,
        ),
      ),
      ItemSync(
        "Thông tin chi tiết",
        DetailInfoView(listing: listing),
      ),
    ];

    if (listing?.listingTypeId == CategoryType.BUY.type &&
        listing?.advantages?.isNotEmpty == true) {
      tabs.add(
        ItemSync(
          "Tiện ích",
          UtilitiesInfoView(listing: listing),
        ),
      );
    } else if (listing?.listingTypeId == CategoryType.RENT.type &&
        listing?.amenities?.isNotEmpty == true) {
      tabs.add(
        ItemSync(
          "Tiện ích",
          UtilitiesInfoView(listing: listing),
        ),
      );
    }

    if (listing?.project != null) {
      tabs.add(
        ItemSync(
          "Dự án",
          ProjectInfoView(listing: listing),
        ),
      );
    }

    return BlocConsumer<DetailListingBloc, DetailListingState>(
      listener: (context, state) {
        if (state is ErrorState) {
          Log.e(state.message);
          Util.showMyDialog(
            context: context,
            message: state.message ?? MessageUtil.errorMessageDefault,
          );
        } else if (state is SuccessGetDetailListingState) {
          setState(() {
            listing = state.listing;
          });

          _detailListingBloc.add(GetListingInteractionEvent(listingId: widget.listingId));
        } else if (state is ErrorGetDetailListingState) {
          _detailListingBloc.add(GetListingInteractionEvent(listingId: widget.listingId));
        } else if (state is SuccessGetListingInteractionState) {
          setState(() {
            interaction = state.listingInteraction;
          });
        }
      },
      bloc: _detailListingBloc,
      builder: (context, state) {
        if (state is LoadingState) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: AppColor.white,
            body: Center(
              child: LoadingView(
                width: 160,
                height: 160,
              ),
            ),
          );
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            child: Column(
              children: [
                Visibility(
                  visible: _isShowAppBar,
                  child: _renderAppBarView(),
                ),
                Expanded(
                  child: ScrollableTabSync(
                    showHideAppBar: (bool isShow) {
                      setState(() {
                        _isShowAppBar = isShow;
                      });
                    },
                    tabs: tabs,
                  ),
                ),
                _renderFooterView(),
              ],
            ),
          ),
        );
      },
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
                      listing?.formatPriceVND ?? "",
                      style: TextStyle(
                        color: AppColor.secondaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      listing?.formatAddress ?? "",
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
    final parentBloc = context.read<DetailListingBloc>();

    return Row(
      children: [
        Visibility(
          visible: Util.isUrl(listing?.vrLink),
          child: InkResponse(
            radius: 24,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailListingExtraPage(
                    listing: listing,
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
        SizedBox(width: 5),
        InkResponse(
          radius: 24,
          onTap: () {
            parentBloc.share(listing?.slug);
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
