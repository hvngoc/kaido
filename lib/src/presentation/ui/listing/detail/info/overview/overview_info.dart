import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewInfoView extends StatefulWidget {
  final Listing? listing;
  final ListingInteraction? interaction;

  const OverviewInfoView({
    Key? key,
    required this.listing,
    required this.interaction,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OverviewInfoViewState();
}

class _OverviewInfoViewState extends State<OverviewInfoView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  'TỔNG QUAN',
                  style: TextStyle(
                    color: AppColor.blackDefault,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 11),
              _renderTrackingInfo(),
              SizedBox(height: 11),
              Html(
                data: widget.listing?.description ?? "",
                // defaultTextStyle: TextStyle(
                //   color: AppColor.blackDefault,
                //   fontSize: 14,
                //   fontWeight: FontWeight.w400,
                // ),
                onLinkTap: (url, context, attributes, element) {
                  if (url != null) {
                    launchUrl(url);
                  }
                },
              ),
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

  Widget _renderTrackingInfo() {
    List<Widget> widgets = [];
    if ((widget.interaction?.numberOfTours ?? 0) > 0) {
      widgets.add(_renderItemTrackingInfo(widget.interaction?.numberOfTours ?? 0, "lượt đi tour"));
    }

    if ((widget.interaction?.numberOfViews ?? 0) > 0) {
      widgets.add(_renderItemTrackingInfo(widget.interaction?.numberOfViews ?? 0, "lượt xem"));
    }

    if ((widget.interaction?.numberOfFavorites ?? 0) > 0) {
      widgets.add(
          _renderItemTrackingInfo(widget.interaction?.numberOfFavorites ?? 0, "lượt yêu thích"));
    }

    if ((widget.interaction?.numberOfShares ?? 0) > 0) {
      widgets.add(_renderItemTrackingInfo(widget.interaction?.numberOfShares ?? 0, "chia sẻ"));
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: HexColor('F4F4F4'),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tương tác 30 ngày qua:',
            style: TextStyle(
              color: HexColor('#898989'),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: GridView.count(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              // primary: false,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: (MediaQuery.of(context).size.height * 0.009),
              crossAxisCount: 2,
              shrinkWrap: true,
              children: widgets,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderItemTrackingInfo(int numberTracking, String valueTracking) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: HexColor('#155AA9'),
            ),
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$numberTracking",
                    style: TextStyle(
                      color: AppColor.blackDefault,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: " $valueTracking",
                    style: TextStyle(
                      color: AppColor.blackDefault,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void launchUrl(String url) async {
    await launch(url);
  }
}
