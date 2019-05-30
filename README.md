# CXScrollViewHoverDemo
UIScrollView嵌套多个Tableview + 悬停效果 

## 效果图如下  

![demo](https://github.com/sunrisechen007/CXScrollViewHoverDemo/blob/master/demo.gif)  


## 设计思路  

![](https://github.com/sunrisechen007/CXScrollViewHoverDemo/blob/master/%E7%BB%93%E6%9E%84%E5%9B%BE.png)

网上看到的一种比较容易理解的 `scrollview` 嵌套多个 `tablview` 左右滑动，外带 `工具条向上滑动悬停效果` 的一种解决方案，这里自己实践了下.    
这种布局，是把 `scollview` 做为底部主视图，它的尺寸就是 `self.view` 的尺寸，它是 `tablview` 的父视图， 而需要悬停的视图`hoverView`的父视图是 `self.view`
,它是在 `scrollview` 的上面一层；这样只要设置好 `tablview` 的 `contentInsets` 使得 `tablvew` top 偏移 `hoverView` 的高度，这样 `hoverView` 就不会遮挡 `tableview` 的显示了。`tableview` 在滚动时，只要保持 `hoverView frame` 的`y`值和 `tableview` 的滚动距离保持一致就可以实现跟随移动了  

## 核心代码  

``` javascript
  /*
   3.修改 mainScrollview 内部的 Tableview 的偏移量，使得刚好头部留出 “头视图+悬停视图” 的高度
   */
  CGFloat topViewHeight = hoverBarViewFrame.size.height + headViewFrame.size.height;
  self.kTopViewHeight = topViewHeight;
  // 表格向下偏移 topViewHeight 的高度
  self.tableview_one.contentInset = UIEdgeInsetsMake(topViewHeight, 0, 0, 0);
  self.tableview_two.contentInset = UIEdgeInsetsMake(topViewHeight, 0, 0, 0);
  // 设置表格的y轴滚动距离，不然的默认为0 实际是向上偏移了 topViewHeight 的距离 （默认表格的y偏移为 -topViewHeight ）
  // contentOffset 与 contentInset 配合使用！
  // ontentOffset.y 默认为 0， 但实际上已经向下偏移了 topViewHeight 的距离，造成的实际结果就是表格上拉了 topViewHeight 距离，为了平衡需要下拉表格，也就是 contentOffset 变为负数
  // 下拉 -  contentOffset的y是越来越小的 （0、-100、-200 ...）
  self.tableview_one.contentOffset = CGPointMake(0, -topViewHeight);
  self.tableview_two.contentOffset = CGPointMake(0, -topViewHeight);

```


``` javascript
/**
 表格滚动回调
 */
- (void)hoverTableViewDidScroll:(HoverTableView *)currentTableView {
    // tmpTableView 表示需要联动的另一个 tableView, 需要保持相同的 contentInset
    HoverTableView *tmpTableView = (currentTableView == self.tableview_one) ? self.tableview_two : self.tableview_one;
    /*
     currentTableView.contentOffset.y 刚开始为 -self.kTopViewHeight
     topOffset 为滚动视图相对于 topView 移动的距离
     */
    CGFloat topOffset = currentTableView.contentOffset.y + self.kTopViewHeight;
    NSLog(@"表格向上移动了%f",topOffset);
    if (topOffset > 0) { // 表格向上移动
        // 1. 保持 topView（headView + hoverBarView）随着表格向上移动（改变y值即可）
        // 1.1 头视图headView 的新frame
        CGRect headViewFrame = self.headView.frame;
        // y值初始为 self.kNavbarHeight
        headViewFrame.origin.y = self.kNavbarHeight - topOffset;
        self.headView.frame = headViewFrame;
        // 1.2 悬停hoverBarView 的新frame
        CGRect tooBarViewFrame = self.hoverBarView.frame;
        tooBarViewFrame.origin.y = CGRectGetMaxY(self.headView.frame);
        
        /*
         hoverBarView 悬停的条件：表格向上移动的距离为headView的高度（headView刚好消失）
         */
        if (topOffset >= headViewFrame.size.height - self.kStatusbarHeight) { // 到达悬停距离啦
            tooBarViewFrame.origin.y = self.kStatusbarHeight;
            // 当其它表格已经悬停了，就不需要再改变 contentInset 了, 不然再来回切换时会有bug
            if (tmpTableView.contentOffset.y <= - (tooBarViewFrame.size.height+self.kStatusbarHeight)) {
                tmpTableView.contentInset = UIEdgeInsetsMake((tooBarViewFrame.size.height+ self.kStatusbarHeight), 0, 0, 0);
                [tmpTableView setContentOffset:CGPointMake(0, -(tooBarViewFrame.size.height+ self.kStatusbarHeight))];
            }
        } else { // 还没到悬停位置时， 其它的表格要跟随当前表格向上移动
            tmpTableView.contentInset = UIEdgeInsetsMake(-currentTableView.contentOffset.y, 0, 0, 0);
            [tmpTableView setContentOffset:CGPointMake(0, currentTableView.contentOffset.y)];
        }
        
        self.hoverBarView.frame = tooBarViewFrame;
        
    } else { // 表格向下移动self.kTopViewHeight距离时，恢复topView的初始尺寸状态
        CGRect headViewFrame = self.headView.frame;
        headViewFrame.origin.y = self.kNavbarHeight;
        self.headView.frame = headViewFrame;
        
        CGRect tooBarViewFrame = self.hoverBarView.frame;
        tooBarViewFrame.origin.y = CGRectGetMaxY(self.headView.frame);
        self.hoverBarView.frame = tooBarViewFrame;
    }
}

```



