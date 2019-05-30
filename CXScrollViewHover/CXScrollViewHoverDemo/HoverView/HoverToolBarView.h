//
//  HoverToolBarView.h
//  CXScrollViewHoverDemo
//
//  Created by Xu Chen on 2019/5/29.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoverToolBarView : UIView
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, copy) void (^segmentSelectedCallback)(NSInteger selecteIndex);

+ (instancetype)mainView;

@end

NS_ASSUME_NONNULL_END
