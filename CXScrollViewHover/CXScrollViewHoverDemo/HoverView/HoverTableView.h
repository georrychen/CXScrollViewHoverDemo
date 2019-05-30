//
//  HoverTableView.h
//  CXScrollViewHoverDemo
//
//  Created by Xu Chen on 2019/5/29.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoverTableView : UITableView
+ (instancetype)loadWithFrame:(CGRect)frame scrollIndex:(NSInteger)scrollIndex;

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

@property (nonatomic, copy) void (^hoverTableViewDidScrollCallback)(HoverTableView *scrollView);
@property (nonatomic, copy) void (^cellClickedCallback)(NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
