# CXScrollViewHoverDemo
UIScrollView嵌套多个Tableview + 悬停效果 

## 效果图如下  

![demo](https://github.com/sunrisechen007/CXScrollViewHoverDemo/blob/master/demo.gif)  


## 设计思路  

![](https://github.com/sunrisechen007/CXScrollViewHoverDemo/blob/master/%E7%BB%93%E6%9E%84%E5%9B%BE.png)

网上看到的一种比较容易理解的 `scrollview` 嵌套多个 `tablview` 左右滑动，外带 `工具条向上滑动悬停效果` 的一种解决方案，这里自己实践了下
这种布局，是把 `scollview` 做为底部主视图，它的尺寸就是 `self.view` 的尺寸，它是 `tablview` 的父视图， 而需要悬停的视图`hoverView`的父视图是 `self.view`
,它是在 `scrollview` 的上面一层；这样只要设置好 `tablview` 的 `contentInsets` 使得 `tablvew` top 偏移 `hoverView` 的高度，这样 `hoverView` 就不会遮挡 `tableview` 的显示了。`tableview` 在滚动时，只要保持 `hoverView frame` 的`y`值和 `tableview` 的滚动距离保持一致就可以实现跟随移动了
