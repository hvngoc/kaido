import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/presentation/view/image_thumbnail_view.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class ImageSlider extends StatefulWidget {
  final Listing? listing;
  final Function(int currentPosition) onClickItemImage;

  ImageSlider({
    Key? key,
    required this.listing,
    required this.onClickItemImage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      child: Stack(
        children: [
          _renderListImage(),
          SafeArea(
            bottom: false,
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _renderBackButton(),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        _renderTagLabelCode(),
                        _renderTagTradeStatus(),
                        Spacer(),
                        _renderItemCount(),
                      ],
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

  Widget _renderListImage() {
    if (widget.listing?.photos == null || widget.listing?.photos?.isEmpty == true) {
      return Container(
        child: ImageThumbnailView(fileUrl: null),
        width: double.infinity,
      );
    } else {
      return PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (int i = 0; i < widget.listing!.photos!.length; i++) ...[
            _renderItemImage(widget.listing?.photos!.elementAt(i).link)
          ]
        ],
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      );
    }
  }

  Widget _renderItemImage(String? imageUrl) {
    return InkWellWithoutRipple(
      onTap: () {
        widget.onClickItemImage.call(selectedIndex);
      },
      child: ImageThumbnailView(fileUrl: imageUrl),
    );
  }

  Widget _renderBackButton() {
    return InkWellWithoutRipple(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 30,
        height: 30,
        margin: EdgeInsets.all(10),
        child: Icon(
          Icons.arrow_back,
          color: HexColor('000000'),
        ),
      ),
    );
  }

  Widget _renderTagLabelCode() {
    if (widget.listing?.labelCode == null) return Container();
    if (widget.listing?.labelCode == "PROPZY_HOME") {
      return Container(
        height: 26,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          "assets/images/vector_ic_logo_propzy_home.svg",
          height: 26,
        ),
      );
    } else {
      return Container(
        height: 26,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.55),
          borderRadius: BorderRadius.circular(3),
        ),
        alignment: Alignment.center,
        child: Text(
          '${widget.listing?.labelName ?? ""}',
          textScaleFactor: 1,
          style: TextStyle(
            color: AppColor.white,
            fontSize: 12,
          ),
        ),
      );
    }
  }

  Widget _renderTagTradeStatus() {
    if (widget.listing?.tradedStatus == null || widget.listing?.tradedStatus?.isEmpty == true)
      return Container();
    return Container(
      height: 26,
      margin: EdgeInsets.only(left: 5),
      padding: EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.55),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        widget.listing?.tradedStatus ?? "",
        overflow: TextOverflow.ellipsis,
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _renderItemCount() {
    if (widget.listing?.photos == null || widget.listing?.photos?.isEmpty == true) {
      return Container(
        height: 20,
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: HexColor('F3F3F3'),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            "1/1",
            style: TextStyle(
              color: HexColor('646464'),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 20,
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: HexColor('F3F3F3'),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            "${(selectedIndex + 1)}/${widget.listing?.photos?.length ?? 1}",
            style: TextStyle(
              color: HexColor('646464'),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
  }
}
