import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/view/image_thumbnail_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  MySliverAppBar({
    required this.title,
    this.avatar,
    this.titleStyle = const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  });

  String title;
  String? avatar;
  final TextStyle titleStyle;

  double? _topPadding;
  double? _centerX;
  Size? _titleSize;
  double? _heightScreen;

  final double _AVATAR_WIDTH_MIN = 70;
  final double _AVATAR_WIDTH_MAX = 160;
  final double _PADDING_AVATAR_TITLE_VERTICAL = 30;
  final double _PADDING_AVATAR_TITLE_HORIZONTAL = 10;
  final double _PADDING_AVATAR_TOP = 15;
  final double _PADDING_AVATAR_LEFT = 30;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    if (_topPadding == null) {
      _topPadding = MediaQuery.of(context).padding.top;
    }
    if (_centerX == null) {
      _centerX = MediaQuery.of(context).size.width / 2;
    }
    if (_heightScreen == null) {
      _heightScreen = MediaQuery.of(context).size.height;
    }
    if (_titleSize == null) {
      _titleSize = _calculateTitleSize(title, titleStyle);
    }

    double percent = shrinkOffset / (maxExtent - minExtent);
    percent = percent > 1 ? 1 : percent;

    return Container(
      color: AppColor.orangeDark,
      child: Stack(
        children: <Widget>[
          _buildImageBg(MediaQuery.of(context).size.width),
          _buildAvatar(percent),
          _buildName(percent),
        ],
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url != null) {
      return ImageThumbnailView(
        fileUrl: url,
        progressColor: Colors.white,
      );
    }
    return Image(
      image: AssetImage(
        'assets/images/no_avatar.png',
      ),
      fit: BoxFit.cover,
    );
  }

  Widget _buildAvatar(double percent) {
    final double _avatarWidth =
        _AVATAR_WIDTH_MAX - (_AVATAR_WIDTH_MAX - _AVATAR_WIDTH_MIN) * percent;
    final double top = _topPadding! + _PADDING_AVATAR_TOP;
    final double left_max = _centerX! - (_avatarWidth / 2);
    final double left_min = _PADDING_AVATAR_LEFT;
    final double left = left_max - ((left_max - left_min) * percent);
    return Positioned(
      top: top,
      left: left,
      child: SizedBox(
        width: _avatarWidth,
        height: _avatarWidth,
        child: ClipOval(
          child: _buildImage(avatar),
        ),
      ),
    );
  }

  Widget _buildName(double percent) {
    double top_max = _topPadding! +
        _PADDING_AVATAR_TOP +
        _AVATAR_WIDTH_MAX +
        _PADDING_AVATAR_TITLE_VERTICAL;
    double top_min = _topPadding! +
        _PADDING_AVATAR_TOP +
        _AVATAR_WIDTH_MIN / 2 -
        (_titleSize!.height / 2);
    double top = top_max - (top_max - top_min) * percent;
    double left_max = _centerX! - (_titleSize!.width / 2) + 10;
    double left_min = _PADDING_AVATAR_LEFT +
        _AVATAR_WIDTH_MIN +
        _PADDING_AVATAR_TITLE_HORIZONTAL;
    double left = left_max - (left_max - left_min) * percent;
    return Positioned(
      top: top,
      left: left,
      child: Container(
        height: maxExtent,
        child: Text(
          title,
          style: titleStyle,
        ),
      ),
    );
    ;
  }

  Widget _buildImageBg(double width) {
    return Positioned(
      bottom: 0,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: maxExtent,
        child: Image(
          width: width,
          image: AssetImage(
            'assets/images/bg_header_profile.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Size _calculateTitleSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  double get maxExtent => 360;

  @override
  double get minExtent => _topPadding! + 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    if (!(oldDelegate is MySliverAppBar)) {
      return false;
    }
    if (oldDelegate.title != title || oldDelegate.avatar != avatar) {
      return true;
    }
    return false;
  }
}
