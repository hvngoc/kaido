import 'package:flutter/material.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class UtilitiesInfoView extends StatefulWidget {
  final Listing? listing;

  const UtilitiesInfoView({Key? key, required this.listing}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UtilitiesInfoViewState();
}

class _UtilitiesInfoViewState extends State<UtilitiesInfoView> {
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
                  'TIỆN ÍCH',
                  style: TextStyle(
                    color: AppColor.blackDefault,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 11),
              _renderListUtilities(),
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

  Widget _renderListUtilities() {
    List<Widget> widgets = [];
    if (widget.listing?.listingTypeId != null) {
      if (widget.listing?.listingTypeId == CategoryType.BUY.type) {
        // ban
        widget.listing?.advantages?.forEach((element) {
          widgets.add(_renderItemUtilities(element.name));
        });
      } else if (widget.listing?.listingTypeId == CategoryType.RENT.type) {
        // thue
        widget.listing?.amenities?.forEach((element) {
          widgets.add(_renderItemUtilities(element.name));
        });
      }
    }

    return Container(
      child: GridView.count(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        // primary: false,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: (MediaQuery.of(context).size.height * 0.006),
        crossAxisCount: 2,
        shrinkWrap: true,
        children: widgets,
      ),
    );
  }

  Widget _renderItemUtilities(String? utility) {
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
            child: Text(
              utility.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColor.blackDefault,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
