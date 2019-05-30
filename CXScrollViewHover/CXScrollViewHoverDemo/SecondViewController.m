//
//  SecondViewController.m
//  CXScrollViewHoverDemo
//
//  Created by Xu Chen on 2019/5/30.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import "SecondViewController.h"
#import "HoverView/HoverTableView.h"
#import "HoverToolBarView.h"
#import "HoverHeadView.h"
#import "MJRefresh/MJRefresh.h"

@interface SecondViewController ()<UIScrollViewDelegate>
/*! 表格1 */
@property (nonatomic, strong) HoverTableView *tableview_one;
/*! 表格2 */
@property (nonatomic, strong) HoverTableView *tableview_two;
/*! 表格数组 */
@property (nonatomic, strong) NSMutableArray *tableViewArray;
/*! 主scrollview */
@property (nonatomic, strong) UIScrollView   *mainScrollView;
/*! 头视图 */
@property (nonatomic, strong) HoverHeadView  *headView;
/*! 需要悬停的控件 */
@property (nonatomic, strong) HoverToolBarView *hoverBarView;
/*! scrollview 的高 */
@property (nonatomic, assign) CGFloat kScrollViewHeight;
/*! 导航栏高 */
@property (nonatomic, assign) CGFloat kNavbarHeight;
/*! topView 的高 */
@property (nonatomic, assign) CGFloat kTopViewHeight;
/*! 状态栏高 */
@property (nonatomic, assign) CGFloat kStatusbarHeight;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupUI {
    self.kStatusbarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    self.kNavbarHeight = 0;
    self.kScrollViewHeight = self.view.frame.size.height - self.kNavbarHeight;
    self.tableViewArray = @[].mutableCopy;
    
    // 1. 添加 mainScrollview(底部主视图，覆盖了整个view)
    self.mainScrollView.frame = CGRectMake(0, self.kNavbarHeight, self.view.frame.size.width, self.kScrollViewHeight);
    [self.view addSubview:self.mainScrollView];
    // 1.1 添加表格1
    self.tableview_one.frame = CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
    __weak typeof(self) weakSelf = self;
    self.tableview_one.hoverTableViewDidScrollCallback = ^(HoverTableView * _Nonnull scrollView) {
        NSLog(@"tableview_one - 偏移 %f",scrollView.contentOffset.y);
        [weakSelf hoverTableViewDidScroll:scrollView];
    };
    self.tableview_one.cellClickedCallback = ^(NSIndexPath * _Nonnull indexPath) {
    };
    [self.mainScrollView addSubview:self.tableview_one];
    [self.tableViewArray addObject:self.tableview_one];
    // 1.2 添加表格2
    self.tableview_two.frame = CGRectMake(self.mainScrollView.frame.size.width, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
    self.tableview_two.hoverTableViewDidScrollCallback = ^(HoverTableView * _Nonnull scrollView) {
        NSLog(@"tableview_two - 偏移 %f",scrollView.contentOffset.y);
        [weakSelf hoverTableViewDidScroll:scrollView];
    };
    [self.mainScrollView addSubview:self.tableview_two];
    [self.tableViewArray addObject:self.tableview_two];
    // 1.3 滚动视图的 contentSize
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width * 2, self.mainScrollView.frame.size.height);
    
    // 2. 添加头视图、需要悬停的视图(都是放在 self.view 上与 mainscrollview 同父视图)
    // 2.1 头视图（headView） (与 mainScrollView top相同)
    CGRect headViewFrame = self.headView.frame;
    headViewFrame.origin.y = self.mainScrollView.frame.origin.y;
    self.headView.frame = headViewFrame;
    [self.headView updateTitle:@"无导航栏的悬停效果"];
    self.headView.palyBtnClickCallback = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
//    系统导航栏的悬停效果（可自定义导航栏）
    [self.view addSubview:self.headView];
    // 2.2 需要悬停的视图（hoverBarView）
    CGRect hoverBarViewFrame = self.hoverBarView.frame;
    hoverBarViewFrame.origin.y = CGRectGetMaxY(self.headView.frame);
    self.hoverBarView.frame = hoverBarViewFrame;
    // segement点击事件
    self.hoverBarView.segmentSelectedCallback = ^(NSInteger selecteIndex) {
        [weakSelf.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.bounds.size.width * selecteIndex, 0) animated:YES];
    };
    [self.view addSubview:self.hoverBarView];
    
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
    
    // 适配 iOS 11
    [self compatibleWith:self.mainScrollView];
    [self compatibleWith:self.tableview_one];
    [self compatibleWith:self.tableview_two];
    // 刷新控件
    [self addMJRefresh];
}

/**
 添加下拉刷新控件
 */
- (void)addMJRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableview_one.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableview_one.header endRefreshing];
        [self alertTips:@"表格1下拉刷新事件"];
    }];
    self.tableview_one.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableview_one.footer endRefreshing];
        [self alertTips:@"表格1加载更多事件"];
    }];
    self.tableview_two.header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf.tableview_two.header endRefreshing];
        [self alertTips:@"表格2下拉刷新事件"];
    }];
    self.tableview_two.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableview_two.footer endRefreshing];
        [self alertTips:@"表格2加载更多事件"];
    }];
}


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


// MARK: xu --------- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        NSInteger scrollIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
        self.hoverBarView.segmentControl.selectedSegmentIndex = scrollIndex;
    }
}


// MARK: xu --------- other

/**
 适配 10 和 11
 */
- (void)compatibleWith:(UIScrollView *)scrollView {
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

/**
 提示框
 */
- (void)alertTips:(NSString *)tip {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:tip message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVc addAction:confirm];
    [self presentViewController:alertVc animated:true completion:nil];
}

/**
 设置状态栏背景颜色
 */
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


// MARK: xu --------- lazyload

- (HoverTableView *)tableview_one {
    if (!_tableview_one) {
        _tableview_one = [HoverTableView loadWithFrame:CGRectZero scrollIndex:0];
        _tableview_one.backgroundColor = UIColor.greenColor;
    }
    return _tableview_one;
}

- (HoverTableView *)tableview_two {
    if (!_tableview_two) {
        _tableview_two = [HoverTableView loadWithFrame:CGRectZero scrollIndex:1];
        _tableview_two.backgroundColor = UIColor.purpleColor;
    }
    return _tableview_two;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = NO;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

- (HoverToolBarView *)hoverBarView {
    if (!_hoverBarView) {
        _hoverBarView = [HoverToolBarView mainView];
    }
    return _hoverBarView;
}

- (HoverHeadView *)headView {
    if (!_headView) {
        _headView = [HoverHeadView mainView];
    }
    return _headView;
}



@end
