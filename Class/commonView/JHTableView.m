//
//  JHTableView.m
//  zsxc
//
//  Created by hyjt on 2017/8/29.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHTableView.h"

@implementation JHTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withSeparateStyle:(JHTableViewSeparateStyle)separateStyle
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0,*)) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
        }
        switch (separateStyle) {
            case 0:
                self.separatorStyle = UITableViewCellSeparatorStyleNone;
                break;
            case 1:
                self.separatorColor = kBaseLineColor;
                break;
            default:
                break;
        }
    }
    return self;
}

@end
