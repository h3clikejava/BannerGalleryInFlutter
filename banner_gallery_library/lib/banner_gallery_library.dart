library banner_gallery_library;

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:banner_gallery_library/page_view_indicator.dart';
import 'package:banner_gallery_library/bean/banner_gallery_bean.dart';

// 轮播的Banner Widget
class BannerGalleryWidget extends StatelessWidget {
  BannerGalleryWidget({
    this.data,
    this.customViewPageItemWidget,
    this.autoScrollDurationSeconds = 5,
    this.onPageTap,
    this.height = 150.0,
    this.bannerScrollDirection = Axis.horizontal,
    this.bannerMargin = const EdgeInsets.only(left: 10.0, right: 10.0),
    this.bannerBorderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.bannerDefaultBGColor = Colors.grey,
    this.bannerTextAlignment = Alignment.center,
    this.bannerTextPadding =
        const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
    this.bannerTextColor = Colors.white,
    this.bannerTextBGColor = Colors.black54,
    this.indicatorPositioned = const Positioned(
      top: 10.0,
    ),
    this.indicatorScrollDirection = Axis.horizontal,
    this.indicatorNormalColor: Colors.white,
    this.indicatorSelectedColor: Colors.white,
    this.indicatorNormalSize: 8.0,
    this.indicatorScaleSize: 1.4,
    this.indicatorSpacing: 4.0,
    this.indicatorStyle: PageViewIndicatorStyle.circle,
    this.indicatorAnimStyle: PageViewIndicatorAnimStyle.scaled,
  });

  /// 内容数据
  final List<BannerGalleryBean> data;

  /// 自定义内容显示样式
  final List<Widget> customViewPageItemWidget;

  /// 自动滑动时间间隔[单位s]
  final int autoScrollDurationSeconds;

  /// Banner滑动方向[水平/垂直]
  final Axis bannerScrollDirection;

  /// Banner之间间距
  final EdgeInsetsGeometry bannerMargin;

  /// Banner圆角
  final BorderRadius bannerBorderRadius;

  /// Banner默认背景颜色
  final Color bannerDefaultBGColor;

  /// Banner文字位置
  final AlignmentGeometry bannerTextAlignment;

  /// Banner文字Padding
  final EdgeInsetsGeometry bannerTextPadding;

  /// Banner文字颜色
  final Color bannerTextColor;

  /// Banner文字背景颜色
  final Color bannerTextBGColor;

  /// 点击的事件监听
  final ValueChanged<int> onPageTap;

  /// View高度
  final double height;

  /// 指示器位置
  final Positioned indicatorPositioned;

  /// 指示器方向 [水平/垂直]
  final Axis indicatorScrollDirection;

  /// 指示器默认颜色
  final Color indicatorNormalColor;

  /// 指示器选中颜色
  final Color indicatorSelectedColor;

  /// 指示器点默认大小
  final double indicatorNormalSize;

  /// 指示器点选中放大倍数，默认1.4倍
  final double indicatorScaleSize;

  /// 指示器点的间距
  final double indicatorSpacing;

  final PageViewIndicatorStyle indicatorStyle;

  /// 指示器动画样式[normal: 选中变色, scaled:选中放大]
  final PageViewIndicatorAnimStyle indicatorAnimStyle;

  /// 轮播控制器
  Timer _timer;

  /// 控制器
  final PageController _controller = PageController(initialPage: 200);

  /// 获得真实数据的长度
  int _getReallyDataSize() {
    return data != null ? data.length : 0;
  }

  /// 有触摸的时候，将轮播控制器状态清空
  _resetTimer() {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = new Timer.periodic(
        new Duration(seconds: autoScrollDurationSeconds), (Timer timer) {
      if (_controller.page != null) {
        var nextPageIndex = _controller.page.toInt() + 1;
        _toPage(nextPageIndex);
      }
    });
  }

  /// 跳转到指定ViewPager
  void _toPage(int page) {
    _controller.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  /// 生成默认的Item样式
  Widget _generateViewPageDefaultItem(BuildContext context, int index) {
    return Container(
        margin: bannerMargin,
        child: Material(
          child: InkWell(
            onTap: () => onPageTap(index),
            onTapDown: _resetTimer(),
            child: ClipRRect(
              borderRadius: bannerBorderRadius,
              child: customViewPageItemWidget != null
                  ? customViewPageItemWidget[index]
                  : _generateDefaultView(index),
            ),
          ),
        ));
  }

  Widget _generateDefaultView(int index) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          color: bannerDefaultBGColor,
          child: CachedNetworkImage(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            fit: BoxFit.cover,
            placeholder: CircularProgressIndicator(),
            imageUrl: data[index].photoUrl,
          ),
        ),
        _generateTextView(data[index].description),
      ],
    );
  }

  /// 动态生成文字区域
  Widget _generateTextView(String content) {
    if (content == null || content.isEmpty) {
      return Container();
    }

    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
          color: bannerTextBGColor,
          padding: bannerTextPadding,
          alignment: bannerTextAlignment,
          child: Text(
            content,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(color: bannerTextColor),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    _resetTimer();

    return SizedBox(
        height: height,
        child: Container(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PageView.builder(
                scrollDirection: bannerScrollDirection,
                controller: _controller,
                itemBuilder: (context, index) {
                  return _generateViewPageDefaultItem(
                      context, index % _getReallyDataSize());
                }),
            Positioned(
              left: indicatorPositioned.left,
              top: indicatorPositioned.top,
              right: indicatorPositioned.right,
              bottom: indicatorPositioned.bottom,
              child: PageViewIndicator(
                controller: _controller,
                itemCount: _getReallyDataSize(),
                size: indicatorNormalSize,
                scrollDirection: indicatorScrollDirection,
                normalColor: indicatorNormalColor,
                selectedColor: indicatorSelectedColor,
                spacing: indicatorSpacing,
                scaleSize: indicatorScaleSize,
                animStyle: indicatorAnimStyle,
                style: indicatorStyle,
                onPageSelected: (int page) {
                  _toPage(page);
                },
              ),
            ),
          ],
        )));
  }
}
