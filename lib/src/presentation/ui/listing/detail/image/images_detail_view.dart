import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/presentation/view/image_thumbnail_view.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:rxdart/rxdart.dart';

///ref: https://pub.dev/packages/photo_view
class ImagesDetailView extends StatefulWidget {
  final Listing? listing;
  final int? currentPositionImage;

  ImagesDetailView({
    Key? key,
    required this.listing,
    this.currentPositionImage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImagesDetailViewState();
}

class _ImagesDetailViewState extends State<ImagesDetailView> {
  late int selectedIndex;
  late PageController _controller;

  bool _isShowButtonNextAndPrevious = false;
  Subject streamShowHideButtons = PublishSubject();

  @override
  void dispose() {
    streamShowHideButtons.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentPositionImage ?? 0;
    _controller = PageController(initialPage: selectedIndex, keepPage: false);

    streamShowHideButtons.stream.debounceTime(Duration(seconds: 3)).listen((event) {
      setState(() {
        _isShowButtonNextAndPrevious = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppColor.gray4A,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Center(
              child: _renderListImage(),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _renderButtonPrevious(),
                    _renderButtonNext(),
                  ],
                ),
              ),
            ),
            _renderItemCount(),
          ],
        ),
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
      return PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(color: AppColor.gray4A),
        builder: (BuildContext context, int i) {
          return PhotoViewGalleryPageOptions.customChild(
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 3,
            child: _renderItemImage(widget.listing?.photos!.elementAt(i).link),
          );
        },
        itemCount: widget.listing?.photos?.length,
        pageController: _controller,
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
        setState(() {
          _isShowButtonNextAndPrevious = true;
        });
        streamShowHideButtons.add(null);
      },
      child: Center(
        child: AspectRatio(
          aspectRatio: 131 / 100,
          child: ImageThumbnailView(
            fileUrl: imageUrl,
          ),
        ),
      ),
    );
  }

  Widget _renderItemCount() {
    return Container(
      height: 24,
      width: 48,
      margin: EdgeInsets.only(bottom: 21, top: 21),
      decoration: BoxDecoration(
        color: HexColor('F3F3F3'),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          "${(selectedIndex + 1)}/${widget.listing?.photos?.length ?? 1}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: HexColor('4A4A4A'),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _renderButtonPrevious() {
    return Visibility(
      visible: _isShowButtonNextAndPrevious,
      child: InkWell(
        onTap: () {
          if (selectedIndex > 0) {
            setState(() {
              selectedIndex = selectedIndex - 1;
            });
            _controller.animateToPage(
              selectedIndex,
              curve: Curves.easeOut,
              duration: Duration(milliseconds: 300),
            );
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/images/ic_arrow_left_white.svg",
              width: 20,
              height: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderButtonNext() {
    return Visibility(
      visible: _isShowButtonNextAndPrevious,
      child: InkWell(
        onTap: () {
          if (selectedIndex < widget.listing!.photos!.length - 1) {
            setState(() {
              selectedIndex = selectedIndex + 1;
            });
            _controller.animateToPage(
              selectedIndex,
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 300),
            );
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/images/ic_arrow_right_white.svg",
              width: 20,
              height: 10,
            ),
          ),
        ),
      ),
    );
  }
}
