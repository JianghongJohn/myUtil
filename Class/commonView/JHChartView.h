//
//  JHChartView.h
//  Demo
//
//  Created by hyjt on 2017/8/5.
//  Copyright © 2017年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHChartView;
//包装坐标点数组里的字典时，所用到的字典key值
extern NSString *const JHChartViewX;
extern NSString *const JHChartViewY;

@interface JHChartView : UIView

/**
 折线图表总体ScrollView、XY坐标、网格、折线
 */
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)UIView *mainView;

//Y最大值
@property(nonatomic,assign)NSInteger maxY;
//Y组数
@property(nonatomic,assign)NSInteger numberY;
//数据值
@property(nonatomic,strong)NSArray *valueData;
//x标题
@property(nonatomic,strong)NSArray *XTitles;
//y标题
@property(nonatomic,strong)NSArray *YTitles;
#pragma 动画相关
//绘制的时候是否需要动画，默认YES
@property (nonatomic, assign) BOOL drawWithAnimation;
//绘制动画时间，默认0.5s
@property (nonatomic, assign) CGFloat drawAnimationDuration;
#pragma mark - 网格
//是否隐藏填充layer，默认NO
@property (nonatomic, assign) BOOL fillLayerHidden;
//填充layer的颜色，默认黑色，透明度0.2
@property (nonatomic, strong) UIColor *fillLayerBackgroundColor;
//是否隐藏网格
@property(nonatomic,assign)BOOL gridHidden;
//网格颜色
@property(nonatomic,strong)UIColor *gridColor;
//线宽
@property(nonatomic,assign)CGFloat widthLine;
//网格宽度
@property(nonatomic,assign)CGFloat widthGrid;
//网格高度
@property(nonatomic,assign)CGFloat heightGrid;
//边缘宽度
@property(nonatomic,assign)CGFloat spaceWidth;
#pragma mark - 折线
//曲线点颜色，默认红色色
@property (nonatomic, strong) UIColor *curvePointColor;
//绘制曲线颜色，默认黑色
@property (nonatomic, strong) UIColor *curveLineColor;
//绘制曲线宽度，默认2.00f
@property (nonatomic, assign) CGFloat curveLineWidth;
#pragma mark - xy坐标轴
//X轴文本高度
@property(nonatomic,assign)CGFloat XLabelHeight;
//Y轴文本宽度
@property(nonatomic,assign)CGFloat YLabelWidth;
//坐标颜色
@property (nonatomic, strong) UIColor *titlesColor;


- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray <NSDictionary *> *)data;

/**
 开始绘制图形或者刷新
 */
-(void)_JHStartChart;
@end
