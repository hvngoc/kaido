import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';

class DetailInfoCard extends StatefulWidget {
  const DetailInfoCard({
    Key? key,
    required this.offerModel,
  }) : super(key: key);

  final HomeOfferModel offerModel;

  @override
  State<DetailInfoCard> createState() => _DetailInfoCardState();
}

class _DetailInfoCardState extends State<DetailInfoCard> {
  bool isExtendedInfo = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _renderHeaderView(),
            SizedBox(height: 16),
            _renderGeneralInfo(),
            SizedBox(height: 16),
            _renderListInfo(),
          ],
        ),
      ),
    );
  }

  Widget _renderOneItem(Map item) {
    final json = widget.offerModel.toJson();
    final keyName = item['keyName'] as String;
    dynamic value = json[keyName];
    String valueDisplay = value != null ? '${value}' : '--';
    if (valueDisplay == '0') {
      valueDisplay = '--';
    }
    String moreDisplay = '';
    if (value == null) {
      valueDisplay = '--';
    } else if (keyName == 'length' || keyName == 'width') {
      valueDisplay += ' m';
    } else if (keyName == 'lotSize' ||
        keyName == 'floorSize' ||
        keyName == 'carpetArea' ||
        keyName == 'builtUpArea') {
      valueDisplay += ' m²';
    } else if (keyName == 'direction' ||
        keyName == 'certificateLand' ||
        keyName == 'expectedTime' ||
        keyName == 'mainDoorDirection' ||
        keyName == 'windowDirection') {
      valueDisplay = (value as HomeIdNameModel).name ?? '--';
    } else if (keyName == 'facadeRoad') {
      final facadeType = widget.offerModel.facadeType ?? 0;

      if (facadeType == Constants.FACADE_TYPE_ID_FOR_FACADE) {
        valueDisplay = 'Mặt tiền';

        final roadWidth = (value as PropzyHomeFacadeContentRoad).roadWidth ?? 0;
        final contiguousName = value.contiguous?.name ?? '';
        moreDisplay = "• Độ rộng mặt tiền: " +
            '${roadWidth} m' +
            "\n" +
            "• Tiếp giáp: " +
            contiguousName;
      } else if (facadeType == Constants.FACADE_TYPE_ID_FOR_ALLEY) {
        value = json['facadeAlley'];
        valueDisplay = 'Trong hẻm';

        final alleyWidth = (value as PropzyHomeFacadeContentAlley).alleyWidth ?? 0;
        final distanceToRoad = value.distanceToRoad ?? 0;
        final contiguousName = value.contiguous?.name ?? '';
        moreDisplay = "• Độ rộng hẻm nhỏ nhất: " +
            '${alleyWidth} m' +
            "\n" +
            "• Khoảng cách đến đường chính: " +
            '${distanceToRoad} m' +
            "\n" +
            "• Tiếp giáp: " +
            contiguousName;
      } else {
        valueDisplay = '--';
      }
    } else if (keyName == 'houseTextures') {
      final listHouseTextures = value as List<HomeHouseTexturesModel>;
      final listParent = listHouseTextures
          .where((element) => element.id! == 1 || element.id == 2);
      final listMore = listHouseTextures
          .where((element) => element.id! != 1 && element.id! != 2);

      valueDisplay =
          listParent.length > 0 ? (listParent.first.name ?? "--") : "--";
      if (valueDisplay != '--' && listMore.length > 0) {
        moreDisplay = listMore.map((e) => '• ${e.name ?? ""}').join('\n');
      }
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  item['iconName'] ?? '',
                  width: 21,
                  height: 21,
                ),
                SizedBox(width: 8),
                Text(
                  item["title"] ?? "",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              valueDisplay,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        Visibility(
          visible: !moreDisplay.isEmpty,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                moreDisplay,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black38,
        ),
      ],
    );
  }

  Widget _collapseButton() {
    final title = isExtendedInfo ? 'Thu gọn' : 'Xem thêm';
    final iconName = isExtendedInfo
        ? 'assets/images/ic_double_arrow_up.svg'
        : 'assets/images/ic_double_arrow_down.svg';
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          isExtendedInfo = !isExtendedInfo;
        });
      },
      child: Container(
        height: 50,
        color: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColor.systemBlue,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              SvgPicture.asset(
                iconName,
                width: 9,
                height: 9,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderListInfo() {
    final _listTotalItems = widget.offerModel.propertyTypeIsApartment()
        ? Constants.list_item_info_property_apartment
        : Constants.list_item_info_property;
    final _listItems = isExtendedInfo
        ? _listTotalItems
        : _listTotalItems.sublist(0, _listTotalItems.length ~/ 2);
    return Column(
      children: [
        ...(_listItems.map((item) => _renderOneItem(item)).toList()),
        _collapseButton(),
      ],
    );
  }

  Widget _renderGeneralInfo() {
    if (widget.offerModel.propertyTypeIsApartment()) {
      return _renderGeneraApartmentInfo();
    } else {
      return _renderGeneralHouseInfo();
    }
  }

  Container _renderGeneralHouseInfo() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromRGBO(116, 116, 128, 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/ic_iBuyer_house_door_fill.svg',
                width: 21,
                height: 21,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.offerModel.propertyType?.typeName ?? '--',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/ic_iBuyer_checkin.svg',
                width: 21,
                height: 21,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(widget.offerModel.address ?? '--'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _renderGeneraApartmentInfo() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromRGBO(116, 116, 128, 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/ic_iBuyer_credit_card.svg',
                width: 21,
                height: 21,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Mã căn hộ - ${widget.offerModel.modelCode ?? ""}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/ic_iBuyer_building.svg',
                width: 21,
                height: 21,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${widget.offerModel.buildingName ?? ""} - ${widget.offerModel.blockBuildingName ?? ""}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/ic_iBuyer_checkin.svg',
                width: 21,
                height: 21,
              ),
              SizedBox(width: 8),
              Flexible(child: Text(widget.offerModel.address ?? '--')),
            ],
          ),
        ],
      ),
    );
  }

  Row _renderHeaderView() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/images/ic_iBuyer_card_checklist.svg',
          width: 21,
          height: 21,
        ),
        SizedBox(width: 10),
        Text(
          'Thông tin về BĐS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
