import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/util/util.dart';

class DemandInfoCard extends StatelessWidget {
  const DemandInfoCard({
    Key? key,
    required this.offerModel,
  }) : super(key: key);

  final HomeOfferModel offerModel;

  @override
  Widget build(BuildContext context) {
    final contactName = offerModel.contactName ?? '--';
    final expectedPriceFrom = offerModel.expectedPriceFrom ?? 0;
    final expectedPriceTo = offerModel.expectedPriceTo ?? 0;
    final expectedPriceDisplay = (expectedPriceFrom > 0 && expectedPriceTo > 0)
        ? '${Util.formatPriceInSuggest(expectedPriceFrom)} - ${Util.formatPriceInSuggest(expectedPriceTo)}'
        : '--';
    final expectedTimeName = offerModel.expectedTime?.name ?? '--';
    final planningToBuy = offerModel.planning?.planningToBuy ?? 0;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // SvgPicture.asset(
                //   'assets/images/ic_iBuyer_calendar_check.svg',
                //   width: 21,
                //   height: 21,
                // ),
                SizedBox(
                  width: 21,
                  height: 21,
                  child: Image(
                    image: AssetImage('assets/images/ic_iBuyer_list_stars.png'),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Nhu cầu của bạn',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            _renderOneItem("Họ tên", contactName),
            _renderOneItem("Mức giá kỳ vọng", expectedPriceDisplay),
            _renderOneItem("Kỳ vọng bán trong", expectedTimeName),
            _renderOneItem(
                "Dự định mua nhà", planningToBuy == 1 ? 'Có' : 'Không'),
          ],
        ),
      ),
    );
  }

  Widget _renderOneItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(title),
          ),
          Text(':'),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
