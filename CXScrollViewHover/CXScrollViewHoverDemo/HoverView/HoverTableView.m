//
//  HoverTableView.m
//  CXScrollViewHoverDemo
//
//  Created by Xu Chen on 2019/5/29.
//  Copyright © 2019 xu.yzl. All rights reserved.
//

#import "HoverTableView.h"

@interface HoverTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger scrollIndex;
@end

@implementation HoverTableView

+ (instancetype)loadWithFrame:(CGRect)frame scrollIndex:(NSInteger)scrollIndex {
    HoverTableView *view = [[HoverTableView alloc ]initWithFrame:frame style:UITableViewStylePlain];
    view.scrollIndex = scrollIndex;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 40;
        self.tableFooterView = [[UIView alloc] init];
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        if (self.scrollIndex) {
            self.backgroundColor = UIColor.greenColor;
        }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个表格 - %ld",self.scrollIndex,indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return UIApplication.sharedApplication.statusBarFrame.size.height > 20 ? 34 : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.cellClickedCallback) {
        self.cellClickedCallback(indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.hoverTableViewDidScrollCallback) {
        self.hoverTableViewDidScrollCallback(self);
    }
}

@end
