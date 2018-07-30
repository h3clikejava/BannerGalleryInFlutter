# BannerGalleryInFlutter
用Flutter实现的无限滑动Banner。

![Screenshot](https://github.com/h3clikejava/BannerGalleryInFlutter/blob/master/photos/Screenshot_v1.gif?raw=true)

可配置的属性

|参数名|参数说明|
|-----|--------|
|customViewPageItemWidget|自定义内容布局|
|autoScrollDurationSeconds|自动滑动时间间隔[单位s]|
|bannerScrollDirection|Banner滑动方向[水平/垂直]|
|bannerMargin|Banner之间间距|
|bannerBorderRadius|Banner圆角|
|bannerDefaultBGColor|Banner默认背景颜色|
|bannerTextAlignment|Banner文字位置|
|bannerTextPadding|Banner文字Padding|
|bannerTextColor|Banner文字颜色|
|bannerTextBGColor|Banner文字背景颜色|
|onPageTap|点击的事件监听|
|height|View高度|
|indicatorPositioned|指示器位置|
|indicatorScrollDirection|指示器方向 [水平/垂直]|
|indicatorNormalColor|指示器默认颜色|
|indicatorSelectedColor|指示器选中颜色|
|indicatorNormalSize|指示器点默认大小|
|indicatorScaleSize|指示器点选中放大倍数，默认1.4倍|
|indicatorSpacing|指示器点的间距|
|indicatorStyle|指示器样式[circle: 圆形, square: 方形]|
|indicatorAnimStyle|指示器动画样式[normal: 选中变色, scaled:选中放大]|


使用示例

```
/// 构建数据
List<BannerGalleryBean> _createTestData() {
    List<BannerGalleryBean> list = new List<BannerGalleryBean>();
    for (int n = 0; n < IMGS.length; n++) {
      list.add(BannerGalleryBean(
          id: n.toString(),
          photoUrl: https://www.baidu.com/img/bd_logo1.png?where=super,
          description: n.toString);
    }
    return list;
  }
  
/// 构建Widget
BannerGalleryWidget(
  data: _createTestData(),
  indicatorSelectedColor: Theme.of(context).primaryColor,
)
```
