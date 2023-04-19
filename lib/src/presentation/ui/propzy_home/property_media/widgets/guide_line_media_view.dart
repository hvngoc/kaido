import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';

class GuideLineMediaView extends StatelessWidget {
  const GuideLineMediaView({
    Key? key,
    this.isLegal = false,
    this.onPressed,
  }) : super(key: key);

  final bool isLegal;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final listGuideMedia = [
      'assets/images/ic_guide_media_wrong_1.png',
      'assets/images/ic_guide_media_right_1.png',
      'assets/images/ic_guide_media_wrong_2.png',
      'assets/images/ic_guide_media_right_2.png',
      'assets/images/ic_guide_media_wrong_3.png',
      'assets/images/ic_guide_media_right_3.png',
      'assets/images/ic_guide_media_wrong_4.png',
      'assets/images/ic_guide_media_right_4.png',
    ];
    final listGuideLegal = [
      'assets/images/ic_guide_legacy_wrong_1.png',
      'assets/images/ic_guide_legacy_right_1.png',
      'assets/images/ic_guide_legacy_wrong_2.png',
      'assets/images/ic_guide_legacy_right_2.png',
      'assets/images/ic_guide_legacy_wrong_3.png',
      'assets/images/ic_guide_legacy_right_3.png',
      'assets/images/ic_guide_legacy_wrong_4.png',
      'assets/images/ic_guide_legacy_right_4.png',
    ];
    final listLegalDescriptions = [
      'Mặt trước sai quy cách',
      'Mặt trước',
      'Mặt sau sai quy cách',
      'Mặt sau',
      'Mặt trong trái sai quy cách',
      'Mặt bên trong trái',
      'Mặt trong phải sai quy cách',
      'Mặt bên trong phải',
    ];
    final listGuide = isLegal ? listGuideLegal : listGuideMedia;
    final title = isLegal
        ? '\"Hướng dẫn chụp ảnh giấy tờ pháp lý, chủ quyền căn nhà\"'
        : '\"Hướng dẫn chụp hình nhà\"';
    final description = isLegal
        ? 'Hình ảnh giấy tờ để vừa khung hình, rõ nội dung giúp Propzy xác thực nhanh hơn'
        : 'Hình ảnh rõ ràng, sáng đẹp, làm nổi bật giá trị căn nhà sẽ giúp bạn bán nhanh, nhận tiền sớm gấp 3 lần';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ListView(
        children: [
          _renderSectionTitle(title),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(),
          Visibility(
            //visible: !isLegal,
            visible: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: _renderSectionTitle('Hướng dẫn quay video'),
            ),
          ),
          Visibility(
            //visible: !isLegal,
            visible: false,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/ic_guide_video.png'),
                  fit: BoxFit.cover,
                ),
                SvgPicture.asset(
                  'assets/images/ic_button_play.svg',
                  width: 64,
                  height: 64,
                ),
              ],
            ),
          ),
          Visibility(
            visible: !isLegal,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: _renderSectionTitle('Hướng dẫn chụp hình'),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: isLegal ? 0.6 : 1.2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: listGuide.length,
            itemBuilder: (BuildContext context, int index) {
              return GuidMediaItemView(
                imageName: listGuide[index],
                isRight: index % 2 == 1,
                descName: isLegal ? listLegalDescriptions[index] : null,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: OrangeButton(
              title: 'Đã hiểu',
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed!();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class GuidMediaItemView extends StatelessWidget {
  const GuidMediaItemView({
    Key? key,
    required this.imageName,
    this.isRight = false,
    this.descName,
  }) : super(key: key);

  final String imageName;
  final bool isRight;
  final String? descName;

  @override
  Widget build(BuildContext context) {
    final iconName = isRight
        ? 'assets/images/ic_check_right_green.svg'
        : 'assets/images/ic_check_wrong_red.svg';
    final iconDesc = descName != null
        ? descName!
        : (isRight ? 'Chụp đúng tiêu chuẩn Propzy' : 'Chụp sai quy cách');
    final iconDescColor = isRight ? Colors.black : Colors.red;
    return Column(
      children: [
        Image(
          image: AssetImage(imageName),
          fit: BoxFit.cover,
        ),
        SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconName,
              width: 24,
              height: 24,
            ),
            SizedBox(width: 2),
            Expanded(
              child: Text(
                iconDesc,
                style: TextStyle(color: iconDescColor, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
