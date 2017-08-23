//
//  JHNoticeScrollView.h
//  JH_NoticeScrollView
//
//  Created by hyjt on 2017/8/1.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHNoticeScrollModel.h"
@interface JHNoticeScrollView : UIView
@property (nonatomic,copy) void (^clickBlock)(NSInteger index);//第几个数据被点击

//数组内部数据需要是类型
- (void)_setVerticalShowDataArr:(NSMutableArray *)dataArr;

//开始滚动
- (void)_start;

//停止定时器(界面消失前必须要停止定时器否则内存泄漏)
- (void)_stopTimer;
@end
