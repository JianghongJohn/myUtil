//
//  JHDrawPersentView.h
//  JHChartViewTest
//
//  Created by hyjt on 2017/8/7.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICountingLabel.h"
@interface JHDrawPercentView : UIView
@property(nonatomic,assign)CGFloat percent;
@property(nonatomic,assign)CGFloat animationTime;
@property(nonatomic,strong)UIColor *startColor;
@property(nonatomic,strong)UIColor *endColor;
@property(nonatomic,strong)UIColor *progressBackGroundColor;
//百分比指示标签
@property (nonatomic,strong) UICountingLabel *labPercent;
@property (nonatomic,strong) UIView *percentView;
- (instancetype)initWithFrame:(CGRect)frame withPercent:(CGFloat )persent;
/**
 开启动画
 */
-(void)_animate;
@end
