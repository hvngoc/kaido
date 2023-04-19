import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/presentation/view/image_thumbnail_view.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:video_player/video_player.dart';

class ListMediaSliderMyOfferScreen extends StatefulWidget {
  final List<HomeFileModel>? files;

  const ListMediaSliderMyOfferScreen({Key? key, this.files}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListMediaSliderMyOfferScreenState();
}

class _ListMediaSliderMyOfferScreenState extends State<ListMediaSliderMyOfferScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              SizedBox.expand(
                child: _renderListMedia(),
              ),
              SafeArea(
                bottom: false,
                child: Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: _renderBackButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderListMedia() {
    if (widget.files == null || widget.files?.isEmpty == true) {
      return Container(
        child: Center(
          child: ImageThumbnailView(fileUrl: null),
        ),
        width: double.infinity,
      );
    } else {
      return PreloadPageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.files?.length ?? 0,
        preloadPagesCount: 3,
        itemBuilder: _renderItemMedia,
      );
    }
  }

  Widget _renderBackButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context, true);
      },
      child: Container(
        child: Image.asset(
          "assets/images/ic_close_circle.png",
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget _renderItemMedia(BuildContext context, int index) {
    HomeFileModel file = widget.files!.elementAt(index);
    if (Constants.MEDIA_FILE_TYPE_VIDEO == file.typeFile) {
      return VideoView(
        url: file.url ?? "",
      );
    } else {
      return SizedBox.expand(
        child: ImageThumbnailView(
          fileUrl: file.url,
        ),
      );
    }
  }
}

class VideoView extends StatefulWidget {
  final String url;

  const VideoView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(false);
          initialized = true;
        });

        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(
              child: Center(
                child: LoadingView(
                  width: 160,
                  height: 160,
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
