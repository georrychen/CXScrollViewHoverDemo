//
//  HoverToolBarView.m
//  CXScrollViewHoverDemo
//
//  Created by Xu Chen on 2019/5/29.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import "HoverToolBarView.h"

@implementation HoverToolBarView


+ (instancetype)mainView {
    HoverToolBarView *view = (HoverToolBarView *)[NSBundle.mainBundle loadNibNamed:@"HoverToolBarView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50);
    return view;
}

- (IBAction)segmentAction:(UISegmentedControl *)sender {
    if (self.segmentSelectedCallback) {
        self.segmentSelectedCallback(sender.selectedSegmentIndex);
    }
}

@end
