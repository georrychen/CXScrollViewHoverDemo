//
//  HoverHeadView.h
//  CXScrollViewHoverDemo
//
//  Created by Xu Chen on 2019/5/29.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoverHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

+ (instancetype)mainView;
@property (nonatomic, copy) void (^palyBtnClickCallback)();
- (void)updateTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
