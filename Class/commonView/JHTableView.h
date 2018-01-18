//
//  JHTableView.h
//  zsxc
//
//  Created by hyjt on 2017/8/29.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JHTableViewSeparateStyle) {
    JHTableViewSeparateStyleNone,
    JHTableViewSeparateStyleLine
};

@interface JHTableView : UITableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withSeparateStyle:(JHTableViewSeparateStyle)separateStyle;
@end
