import 'package:flutter/material.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/presentation/view/image_thumbnail_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class CollectionMediaCard extends StatelessWidget {
  const CollectionMediaCard({
    Key? key,
    required this.offerModel,
    this.type = 1,
  }) : super(key: key);

  final HomeOfferModel offerModel;
  final int type; // 1: hình nhà, 2: là pháp lý, 3: là video

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
            _renderGridView(),
          ],
        ),
      ),
    );
  }

  Widget _renderOneItem(HomeFileModel file) {
    final boxFit = BoxFit.cover;
    final borderRadius = 4.0;
    final captionName = file.caption?.name ?? 'Khác';
    final fileType = file.typeFile ?? 0;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: ImageThumbnailView(
              fileUrl: file.url,
              boxFit: boxFit,
              errImage: 'assets/images/img_no_image.png',
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          right: 40,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: AppColor.black_40p,
            ),
            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: Text(
              captionName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Visibility(
          visible: fileType == 2,
          child: Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image(image: AssetImage('assets/images/ic_button_play.png'),),
            ),
          ),
        ),
      ],
    );
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(8),
    //     color: Colors.yellow,
    //   ),
    //   child: ImageThumbnailView(
    //     fileUrl: file.url,
    //     boxFit: boxFit,
    //     errImage: 'assets/images/img_no_image.png',
    //   ),
    // );
  }

  Widget _renderGridView() {
    final files = offerModel.files ?? [];
    var listData = files.where((file) {
      final typeSource = file.typeSource ?? 0;
      if (type == 1 && typeSource == 1) {
        return true;
      }
      if (type == 2 && typeSource == 2) {
        return true;
      }
      return false;
    }).toList();
    listData.sort((file1, file2) {
      final captionId1 = file1.caption?.id ?? 999999;
      final captionId2 = file2.caption?.id ?? 999999;
      return captionId1.compareTo(captionId2);
    });
    if (listData.length == 0) {
      return _renderEmptyView();
    }
    return GridView.count(
      // primary: false,
      padding: const EdgeInsets.symmetric(vertical: 16),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: listData.map((file) => _renderOneItem(file)).toList(),
    );
  }

  Widget _renderEmptyView() {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          SizedBox(
            width: 120,
            child: Image(
              image: AssetImage('assets/images/img_no_image.png'),
            ),
          ),
          SizedBox(height: 10),
          Text('Chưa có thông tin'),
        ],
      ),
    );
  }

  Widget _renderHeaderView() {
    final titleString =
        type == 1 ? 'Video/hình ảnh BĐS' : 'Hình ảnh giấy tờ pháp lý';
    return Row(
      children: [
        SizedBox(
          width: 21,
          height: 21,
          child: Image(
            image: AssetImage('assets/images/ic_media.png'),
          ),
        ),
        SizedBox(width: 8),
        Text(
          titleString,
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
