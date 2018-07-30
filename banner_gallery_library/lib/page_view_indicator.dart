import 'dart:math';

import 'package:flutter/material.dart';

/// 滑动指示器的样式
enum PageViewIndicatorStyle {
  /// 圆形
  circle,

  /// 正方形
  square,
}

/// 滑动指示器的动画样式
enum PageViewIndicatorAnimStyle {
  /// 正常模式
  normal,

  /// 缩放模式，选中的变大
  scaled,
}

/// PageView滑动指示器
class PageViewIndicator extends AnimatedWidget {
  PageViewIndicator({
    this.controller,
    this.itemCount: 0,
    this.onPageSelected,
    this.scrollDirection = Axis.horizontal,
    this.normalColor: Colors.white,
    this.selectedColor: Colors.white,
    this.size: 8.0,
    this.spacing: 4.0,
    this.scaleSize: 1.4,
    this.style: PageViewIndicatorStyle.circle,
    this.animStyle: PageViewIndicatorAnimStyle.normal,
  })  : assert(controller != null),
        super(listenable: controller);

  /// PageView的控制器
  final PageController controller;

  /// 指示器的个数
  final int itemCount;

  /// 点击的事件监听
  final ValueChanged<int> onPageSelected;

  /// 方向
  final Axis scrollDirection;

  /// 普通的颜色
  final Color normalColor;

  /// 选中的颜色
  final Color selectedColor;

  /// 点的大小
  final double size;

  /// 点的间距
  final double spacing;

  /// 点的样式
  final PageViewIndicatorStyle style;

  /// 动画样式
  final PageViewIndicatorAnimStyle animStyle;

  /// 选中放大的倍数
  final double scaleSize;

  /// 点的Widget
  Widget _buildIndicator(int index, int pageCount, double dotSize,
      double spacing, double maxZoom) {
    // 当前未知
    double currentPosition =
        ((controller.page ?? controller.initialPage.toDouble()) %
            pageCount.toDouble());

    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - (currentPosition - index).abs(),
      ),
    );

    // 是否是当前页面被选中
    bool isCurrentPageSelected = index ==
        (controller.page != null ? controller.page.round() % pageCount : 0);

    // 修复从0跳到最后一个时状态错误
    if (currentPosition > pageCount - 1 && index == 0) {
      selectedness = 1 - (pageCount.toDouble() - currentPosition);
    }

    // 计算缩放大小
    double zoom = 1.0 + (maxZoom - 1.0) * selectedness;

    // 取中间色
    final ColorTween selectedColorTween =
        ColorTween(begin: normalColor, end: selectedColor);

    return Container(
      width: size + (2 * spacing),
      height: size + (2 * spacing),
      child: Center(
        child: Material(
          shadowColor: Colors.black,
          elevation: 2.0,
          color: selectedColorTween.lerp(selectedness),
          type: style == PageViewIndicatorStyle.circle
              ? MaterialType.circle
              : MaterialType.button,
          child: Container(
            width: dotSize * zoom,
            height: dotSize * zoom,
            child: InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (scrollDirection == Axis.vertical) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(itemCount, (int index) {
          return _buildIndicator(index, itemCount, size, spacing,
              animStyle == PageViewIndicatorAnimStyle.scaled ? scaleSize : 1.0);
        }),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(itemCount, (int index) {
          return _buildIndicator(index, itemCount, size, spacing,
              animStyle == PageViewIndicatorAnimStyle.scaled ? scaleSize : 1.0);
        }),
      );
    }
  }
}
