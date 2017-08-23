//
//  JHChartView.m
//  Demo
//
//  Created by hyjt on 2017/8/5.
//  Copyright © 2017年 wazrx. All rights reserved.
//

#import "JHChartView.h"
//包装坐标点数组里的字典时，所用到的字典key值
NSString *const JHChartViewX = @"JHChartViewX";
NSString *const JHChartViewY = @"JHChartViewY";
@interface JHChartView()
//x代表平行x轴
@property (nonatomic, weak) CAReplicatorLayer *xReplicatorLayer;//复制图层
@property (nonatomic, weak) CAReplicatorLayer *yReplicatorLayer;//复制图层
@property (nonatomic, weak) CALayer *xBackLine;
@property (nonatomic, weak) CALayer *yBackLine;
@property (nonatomic, weak) CAShapeLayer *backLayer;//背景
@property (nonatomic, weak) CAShapeLayer *curveLineLayer;//曲线
@property (nonatomic, strong) UIBezierPath *path;//曲线路劲
@property (nonatomic, strong) UIBezierPath *backPath;//曲线路劲
@property (nonatomic,strong)UILabel *numberLabel;//点击展示的标记
@property (nonatomic,strong)UIView *XLabelView;//X坐标视图
@property (nonatomic,strong)UIView *YLabelView;//Y坐标视图
//数据值
@property(nonatomic,strong)NSMutableArray *pointData;
@end
@implementation JHChartView

- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray <NSDictionary *> *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        _widthGrid  = 50;
        _widthLine  = 0.5;
        _heightGrid = 20;
        _numberY    = 10;
        _maxY = 100;
        _spaceWidth = 10;
        _drawAnimationDuration = 1.0;
        _YLabelWidth = 40;
        _XLabelHeight = 20;
        _titlesColor = [UIColor blackColor];
        _gridColor  = [UIColor lightGrayColor];
        _curvePointColor = [UIColor redColor];
        _fillLayerBackgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _curveLineWidth = 2.0;
        _curveLineColor = [UIColor blackColor];
        _drawWithAnimation = YES;
        _valueData = data;
        
    }
    return self;
}

/**
 创建子视图
 */
-(void)_creatSubViews{
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    _scrollView = scroll;
    [self addSubview:scroll];
    //主要的一个视图
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor yellowColor];
    _mainView= mainView;
    [scroll addSubview:mainView];
    
    //坐标轴
    UIView *XLabel = [UIView new];
    _XLabelView = XLabel;
    [mainView addSubview:XLabel];
    UIView *YLabel = [UIView new];
    _YLabelView = YLabel;
    [mainView addSubview:YLabel];
    
    //封闭阴影
    CAShapeLayer * backLayer = [CAShapeLayer new];
    _backLayer = backLayer;
    [mainView.layer addSublayer:backLayer];
    //添加网格
    //网格列线
    CAReplicatorLayer *rowReplicatorLayer = [CAReplicatorLayer new];
    _xReplicatorLayer = rowReplicatorLayer;
    rowReplicatorLayer.position = CGPointMake(0, 0);
    CALayer *rowBackLine = [CALayer new];
    _xBackLine = rowBackLine;
    [rowReplicatorLayer addSublayer:rowBackLine];
    [mainView.layer addSublayer:rowReplicatorLayer];
    //网格横线
    
    CAReplicatorLayer *columnReplicatorLayer = [CAReplicatorLayer new];
    _yReplicatorLayer = columnReplicatorLayer;
    columnReplicatorLayer.position = CGPointMake(0, 0);
    CALayer *columnBackLine = [CALayer new];
    _yBackLine = columnBackLine;
    [columnReplicatorLayer addSublayer:columnBackLine];
    [mainView.layer addSublayer:columnReplicatorLayer];
    
    //曲线
    CAShapeLayer *curveLineLayer = [CAShapeLayer new];
    _curveLineLayer = curveLineLayer;
    curveLineLayer.fillColor = nil;
    curveLineLayer.lineJoin = kCALineJoinRound;
    [mainView.layer addSublayer:curveLineLayer];
    
    //弹出数字
    [mainView addSubview:self.numberLabel];
    self.numberLabel.hidden = YES;
}

/**
 布局(给mainView右侧增加了间隙，为了解决按钮点击不全的问题)
 */
-(void)_layout{
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //宽度高度都 = 网格数量+网格线数量 + 坐标大小
    //宽度增加space，解决点击bug
    _mainView.frame = CGRectMake(_spaceWidth,_spaceWidth, (_valueData.count-1)*_widthGrid+(_valueData.count)*_widthLine+_YLabelWidth+_spaceWidth, _numberY*_heightGrid+(_numberY+1)*_widthLine+_XLabelHeight);
    _scrollView.contentSize = CGSizeMake(_mainView.frame.size.width+(_widthGrid+_widthLine)/2, _mainView.frame.size.height+_spaceWidth*2);
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    
    CGFloat rowSpacing = _heightGrid;
    CGFloat columnSpacing = _widthGrid;
    //坐标轴
    _XLabelView.frame = CGRectMake(_YLabelWidth-_widthGrid/2, _mainView.frame.size.height-_XLabelHeight, _mainView.frame.size.width-_YLabelWidth, _XLabelHeight);
    _YLabelView.frame = CGRectMake(0, 0-_heightGrid/2,_YLabelWidth,_mainView.frame.size.height-_XLabelHeight);
    //图层复制
    _xReplicatorLayer.instanceCount = _numberY+1;
    _yReplicatorLayer.instanceCount = _valueData.count;
    _xBackLine.frame = CGRectMake(0, 0, _mainView.frame.size.width-_YLabelWidth-_spaceWidth, _widthLine);
    _xReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, rowSpacing + _widthLine, 0);
    
    _yReplicatorLayer.frame = _xReplicatorLayer.frame = CGRectMake(_YLabelWidth, 0, _mainView.frame.size.width-_YLabelWidth-_spaceWidth, _mainView.frame.size.height-_XLabelHeight);
    
    _yBackLine.frame = CGRectMake(0, 0, _widthLine, _mainView.frame.size.height-_XLabelHeight);
    
    _yReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(columnSpacing + _widthLine, 0, 0);
    //曲线
    _curveLineLayer.strokeColor = _curveLineColor.CGColor;
    _curveLineLayer.lineWidth = _curveLineWidth;
    //背景
    _backLayer.fillColor = _fillLayerBackgroundColor.CGColor;
    _backLayer.hidden = _fillLayerHidden;
    
    //网格
    _xReplicatorLayer.hidden = _yReplicatorLayer.hidden = _gridHidden;
    _yBackLine.backgroundColor = _xBackLine.backgroundColor = _gridColor.CGColor;
    
    
    [CATransaction commit];
}

/**
 生成坐标点
 */
-(void)_creatPoint{
    _pointData = @[].mutableCopy;
    for (NSDictionary *dict in _valueData) {
        CGPoint point = [self _changeValueToPoint:dict];
        [_pointData addObject:[NSValue valueWithCGPoint:point]];
    }
    
}
/**
 将数值转换成坐标
 */
-(CGPoint )_changeValueToPoint:(NSDictionary *)data{
    CGFloat xValue = [data[JHChartViewX] floatValue];
    CGFloat yValue = [data[JHChartViewY] floatValue];
    //x坐标等于value*宽度
    //y坐标等于value/最大值*y高度
    CGPoint point = CGPointMake(_YLabelWidth + xValue *(_widthGrid + _widthLine),(1-yValue/_maxY)*_yBackLine.frame.size.height);
    return point;
    
}

/**
 生成路径
 */
-(void)_creatPath{
    
    [self _creatPoint];
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    UIBezierPath *backPath = [UIBezierPath bezierPath];
    CGPoint firstPoint = [_pointData[0] CGPointValue];
    CGPoint lastPoint = [_pointData[_pointData.count - 1] CGPointValue];
    [path moveToPoint:firstPoint];
    [backPath moveToPoint:CGPointMake(firstPoint.x, _yBackLine.frame.size.height)];
    for (NSValue *pointValue in _pointData) {
        CGPoint point = [pointValue CGPointValue];
        if (pointValue == _pointData[0]) {
            [backPath addLineToPoint:point];
            continue;
        }
        [backPath addLineToPoint:point];
        [path addLineToPoint:point];
    }
    [backPath addLineToPoint:CGPointMake(lastPoint.x, _yBackLine.frame.size.height)];
    _path = path;
    _backPath = backPath;
    
}

/**
 绘制路径
 */
-(void)_drawPath{
    [self _creatPath];
    
    //画曲线上的点
    for(int i=0; i<[_pointData count]; i++){
        [self drawPoint:[[_pointData objectAtIndex:i] CGPointValue] withIndex:i];
        
    }
    _backLayer.path = _backPath.CGPath;
    
    _curveLineLayer.path = _path.CGPath;
    _curveLineLayer.strokeEnd = 1;
    if (_drawWithAnimation) {
        CABasicAnimation *pointAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pointAnim.fromValue = @0;
        pointAnim.toValue = @1;
        pointAnim.duration = _drawAnimationDuration;
        [_curveLineLayer addAnimation:pointAnim forKey:@"drawLine"];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        //    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        //    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @0.0f;
        opacityAnimation.toValue   = @1.0f;
        opacityAnimation.duration = _drawAnimationDuration;
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.removedOnCompletion = NO;
        [_backLayer addAnimation:opacityAnimation forKey:@"drawBack"];
    }
    
    
}


/**
 绘制坐标点
 
 @param point 坐标点
 @param index 标记tag
 */
- (void)drawPoint:(CGPoint)point withIndex:(NSInteger)index{
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(0, 0, 8, 8);
    btn.center = point;
    btn.layer.cornerRadius = 4;
    btn.tag = index;
    btn.backgroundColor = _curvePointColor;
    
    [_mainView addSubview:btn];
    [btn addTarget:self action:@selector(_pointAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)_pointAction:(UIButton *)btn{
    NSString *number = [NSString stringWithFormat:@"%@",_valueData[btn.tag][JHChartViewY]];
    _numberLabel.text = number;
    _numberLabel.hidden = NO;
    _numberLabel.alpha = 0;
    CGSize size = [number sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
    
    _numberLabel.frame = CGRectMake(_numberLabel.frame.origin.x,_numberLabel.frame.origin.y,size.width, size.height);
    _numberLabel.center = CGPointMake(btn.center.x, btn.center.y-10);
    [UIView animateWithDuration:1 animations:^{
        _numberLabel.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    NSLog(@"%@",number);
}
-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _numberLabel.backgroundColor = [UIColor whiteColor];
        _numberLabel.textColor = [UIColor redColor];
        _numberLabel.layer.cornerRadius = 3;
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.font = [UIFont systemFontOfSize:10];
        
        //        _numberLabel.hidden = YES;
    }
    return  _numberLabel;
}
#pragma mark - 坐标轴

/**
 x坐标
 */
-(void)_creatXLabels{
    
    if (!_XTitles) {
        for (int i = 0; i<_valueData.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*(_widthGrid+_widthLine), 0,(_widthGrid+_widthLine) , _XLabelHeight)];
            label.text = [NSString stringWithFormat:@"%d",i+1];
            label.textColor = _titlesColor;
            label.font = [UIFont systemFontOfSize:10];
            label.textAlignment = NSTextAlignmentCenter;
            [_XLabelView addSubview:label];
        }
        return;
    }
    NSAssert(_XTitles.count ==_valueData.count, @"x坐标文本数量必须与x值数量相同");
    for (NSString *title in _XTitles) {
        NSInteger index = [_XTitles indexOfObject:title];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(index*(_widthGrid+_widthLine), 0,(_widthGrid+_widthLine) , _XLabelHeight)];
        label.text = title;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = _titlesColor;
        label.textAlignment = NSTextAlignmentCenter;
        [_XLabelView addSubview:label];
    }
}

/**
 y坐标
 */
-(void)_creatYLabels{
    if (!_YTitles) {
        for (int i = 0; i<_numberY; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i*(_heightGrid+_widthLine),_YLabelWidth,_heightGrid+_widthLine)];
            label.text = [NSString stringWithFormat:@"%ld",_maxY/_numberY*(_numberY-i)];
            label.textColor = _titlesColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            [_YLabelView addSubview:label];
        }
        return;
    }
    //    NSAssert(_YTitles.count!= _numberY, @"y坐标文本数量必须与设定的y值数量相同");
    //    for (NSString *title in _YTitles) {
    //        NSInteger index = [_XTitles indexOfObject:title];
    //
    //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, index*(_heightGrid+_widthLine),_YLabelWidth,_heightGrid+_widthLine)];
    //        label.text = title;
    //        label.textColor = _titlesColor;
    //        label.textAlignment = NSTextAlignmentCenter;
    //        [_YLabelView addSubview:label];
    //
    //    }
}

/**
 开始绘制图形或者刷新
 */
-(void)_JHStartChart{
    //清除旧视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self _creatSubViews];
    [self _layout];
    [self _creatXLabels];
    [self _creatYLabels];
    [self _drawPath];
    
}
@end
