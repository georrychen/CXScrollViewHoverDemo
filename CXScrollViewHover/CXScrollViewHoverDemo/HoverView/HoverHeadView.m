//
//  HoverHeadView.m
//  CXScrollViewHoverDemo
//
//  Created by Xu Chen on 2019/5/29.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import "HoverHeadView.h"

@implementation HoverHeadView

+ (instancetype)mainView {
    HoverHeadView *view = (HoverHeadView *)[NSBundle.mainBundle loadNibNamed:@"HoverHeadView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 200);
    return view;
}


- (IBAction)playButtonAction:(id)sender {
    if (self.palyBtnClickCallback) {
        self.palyBtnClickCallback();
    }
}


- (void)updateTitle:(NSString *)title {
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}

@end
