//
//  JHChartView.m
//  Demo
//
//  Created by hyjt on 2017/8/5.
//  Copyright © 2017年 wazrx. All rights reserved.
//

#import "JHChartView.h"
#import "NSString+ChangeTime.h"
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
@property (nonatomic, weak) CAShapeLayer *progressLayer;//背景遮罩
@property (nonatomic, weak) CAShapeLayer *curveLineLayer;//曲线
@property (nonatomic, strong) UIBezierPath *path;//曲线路劲
@property (nonatomic, strong) UIBezierPath *backPath;//曲线路劲
@property (nonatomic,strong)UILabel *numberLabel;//点击展示的标记
@property (nonatomic,strong)UIView *XLabelView;//X坐标视图
@property (nonatomic,strong)UIView *YLabelView;//Y坐标视图

//数据值
@property(nonatomic,strong)NSMutableArray *pointData;
@property(nonatomic,assign)CGFloat sumLineWidth;
@end
@implementation JHChartView

- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray <NSDictionary *> *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        _valueData = data;
        
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self _layout];
    if (_XLabelView.subviews.count<1) {
        [self _creatXLabels];
        [self _creatYLabels];
        [self _drawPath];
    }

}
/**
 默认数据
 */
-(void)initData{
    _widthGrid  = 50;
    _widthLine  = 0.5;
    _heightGrid = 25;
    _YunitLabelHeight = 25;
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
}
/**
 创建子视图
 */
-(void)_creatSubViews{
    
    _menuBtn = [[JHMenuBtn alloc] initWithFrame:CGRectMake(self.frame.size.width/2-100, 10, 200, 30) withTitles:@[@"近一月",@"近一年"]];
    _menuBtn.selectIndex = self.selectIndex;
    _menuBtn.delegate = self;
    [self addSubview:_menuBtn];
    
    UIScrollView *scroll    = [[UIScrollView alloc] init];
    _scrollView             = scroll;
    [self addSubview:scroll];
    //主要的一个视图
    UIView *mainView            = [[UIView alloc] init];
    mainView.backgroundColor    = [UIColor whiteColor];
    _mainView= mainView;
    [scroll addSubview:mainView];
    
    //y坐标轴不跟随滚动
    UIView *XLabel          = [UIView new];
    _XLabelView             = XLabel;
    [mainView addSubview:XLabel];
    UIView *YLabel          = [UIView new];
    YLabel.backgroundColor  = [UIColor whiteColor];
    _YLabelView             = YLabel;
    [self addSubview:YLabel];
    
    //封闭阴影
    CAShapeLayer * backLayer    = [CAShapeLayer new];
    _backLayer                  = backLayer;
    [mainView.layer addSublayer:backLayer];
    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    _progressLayer              = progressLayer;
    [_backLayer setMask:progressLayer];
    //添加网格
    //网格列线
    CAReplicatorLayer *rowReplicatorLayer   = [CAReplicatorLayer new];
    _xReplicatorLayer                       = rowReplicatorLayer;
    rowReplicatorLayer.position             = CGPointMake(0, 0);
    CALayer *rowBackLine                    = [CALayer new];
    _xBackLine                              = rowBackLine;
    [rowReplicatorLayer addSublayer:rowBackLine];
    [mainView.layer addSublayer:rowReplicatorLayer];
    //网格横线
    
    CAReplicatorLayer *columnReplicatorLayer    = [CAReplicatorLayer new];
    _yReplicatorLayer                           = columnReplicatorLayer;
    columnReplicatorLayer.position              = CGPointMake(0, 0);
    CALayer *columnBackLine                     = [CALayer new];
    _yBackLine                                  = columnBackLine;
    [columnReplicatorLayer addSublayer:columnBackLine];
    [mainView.layer addSublayer:columnReplicatorLayer];
    
    //曲线
    CAShapeLayer *curveLineLayer    = [CAShapeLayer new];
    _curveLineLayer                 = curveLineLayer;
    curveLineLayer.fillColor        = nil;
    curveLineLayer.lineJoin         = kCALineJoinRound;
    [mainView.layer addSublayer:curveLineLayer];
    
    //弹出数字
//    [mainView addSubview:self.numberLabel];
//    self.numberLabel.hidden = YES;
    
    //y单位
    [self addSubview:self.YunitLabel];
}

/**
 布局(给mainView右侧增加了间隙，为了解决按钮点击不全的问题)
 */
-(void)_layout{
    
    _menuBtn.frame = CGRectMake(self.frame.size.width/2-100, 10, 200, 30);
    _scrollView.frame = CGRectMake(_spaceWidth, _menuBtn.bottom, self.frame.size.width-_spaceWidth, self.frame.size.height-40);
    //宽度高度都 = 网格数量+网格线数量 + 坐标大小
    //宽度增加space，解决点击bug
    _mainView.frame = CGRectMake(_spaceWidth,_spaceWidth, (_valueData.count-1)*_widthGrid+(_valueData.count)*_widthLine+_YLabelWidth+_spaceWidth, _numberY*_heightGrid+(_numberY+1)*_widthLine+_XLabelHeight+_YunitLabelHeight);
    _scrollView.contentSize = CGSizeMake(_mainView.frame.size.width+(_widthGrid+_widthLine)/2, _mainView.frame.size.height+_spaceWidth*2);
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    
    CGFloat rowSpacing = _heightGrid;
    CGFloat columnSpacing = _widthGrid;
    //单位
    CGSize size = [_YunitLabel.text sizeWithAttributes:@{NSFontAttributeName: _YunitLabel.font}];
    _YunitLabel.frame = CGRectMake(0,_scrollView.top - _heightGrid/2 + _spaceWidth,size.width, _YunitLabelHeight);
    //坐标轴
    _XLabelView.frame = CGRectMake(_YLabelWidth-_widthGrid/2, _mainView.frame.size.height, _mainView.frame.size.width-_YLabelWidth, _XLabelHeight);
    _YLabelView.frame = CGRectMake(0, _scrollView.top+_spaceWidth+_heightGrid/2,_YLabelWidth,_scrollView.frame.size.height-_YunitLabelHeight);
    //图层复制
    _xReplicatorLayer.instanceCount = _numberY+1;
    _yReplicatorLayer.instanceCount = _valueData.count;
    
    _xReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, rowSpacing + _widthLine, 0);
    _yReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(columnSpacing + _widthLine, 0, 0);
    
    _yReplicatorLayer.frame = _xReplicatorLayer.frame = CGRectMake(_YLabelWidth, _YunitLabelHeight, _mainView.frame.size.width-_YLabelWidth-_spaceWidth, _mainView.frame.size.height-_XLabelHeight-_YunitLabelHeight);
    
    _yBackLine.frame = CGRectMake(0, 0, _widthLine, _yReplicatorLayer.frame.size.height);
    _xBackLine.frame = CGRectMake(0, 0, _yReplicatorLayer.frame.size.width, _widthLine);
    //曲线
    _curveLineLayer.strokeColor = _curveLineColor.CGColor;
    _curveLineLayer.lineWidth = _curveLineWidth;
    //背景
    _backLayer.fillColor = _fillLayerBackgroundColor.CGColor;
    _backLayer.hidden = _fillLayerHidden;
    //背景移动遮罩
    CGFloat lineWidth = _yReplicatorLayer.frame.size.height+_YunitLabelHeight;
    _progressLayer.lineWidth = lineWidth*2;
    _progressLayer.lineCap = kCALineCapSquare;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    //将路径填充颜色设置为透明
    _progressLayer.fillColor = [UIColor redColor].CGColor;
    
    //网格
    _xReplicatorLayer.hidden = _yReplicatorLayer.hidden = _gridHidden;
    _yBackLine.backgroundColor = _xBackLine.backgroundColor = _gridColor.CGColor;
    //当前天滚动到中间
    [self scrollShowDoday];
    [CATransaction commit];
}

/**
 生成坐标点
 */
-(void)_creatPoint{
    _pointData = @[].mutableCopy;

    for (NSDictionary *dict in _valueData) {
        //截取显示到当前这天
        if ([dict[JHChartViewX] integerValue] == self.currentDate ) {
            break;
        }
        CGPoint point = [self _changeValueToPoint:dict];
        if (isnan(point.y)) {
            point = CGPointMake(point.x, _YunitLabelHeight+_yBackLine.frame.size.height);
        }
        [_pointData addObject:[NSValue valueWithCGPoint:point]];
    }
    CGFloat sum = 0;
    //计算总长度
    for (int i = 0; i<_pointData.count-1; i++) {
        //当前之后不计算
        if (self.currentDate==i) {
            break;
        }
      CGPoint p1 = [_pointData[i] CGPointValue];
      CGPoint p2 = [_pointData[i+1] CGPointValue];
        CGFloat temp = sqrt( pow((p1.x-p2.x), 2)+pow((p1.y-p2.y), 2));
        sum += temp;
    }
    _sumLineWidth = sum;
}
/**
 将数值转换成坐标
 */
-(CGPoint )_changeValueToPoint:(NSDictionary *)data{
    CGFloat xValue = [data[JHChartViewX] floatValue];
    CGFloat yValue = [data[JHChartViewY] floatValue];
    //x坐标等于value*宽度
    //y坐标等于value/最大值*y高度
    CGPoint point = CGPointMake(_YLabelWidth + xValue *(_widthGrid + _widthLine),_YunitLabelHeight+(1-yValue/_maxY)*_yBackLine.frame.size.height);
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
    [backPath moveToPoint:CGPointMake(firstPoint.x, _yBackLine.frame.size.height+_YunitLabelHeight)];
    for (NSValue *pointValue in _pointData) {
        CGPoint point = [pointValue CGPointValue];
        if (pointValue == _pointData[0]) {
            [backPath addLineToPoint:point];
            continue;
        }
        [backPath addLineToPoint:point];
        [path addLineToPoint:point];
    }
    [backPath addLineToPoint:CGPointMake(lastPoint.x, _yBackLine.frame.size.height+_YunitLabelHeight)];
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
    //绘制数字
    [self _creatNumberLabels];
    //背景路劲
    _backLayer.path = _backPath.CGPath;
    //曲线
    _curveLineLayer.path = _path.CGPath;
    _curveLineLayer.strokeEnd = 1;
    if (_drawWithAnimation) {
        CGFloat newDuration = (_currentDate-1)/(_valueData.count-1) * _drawAnimationDuration;
        CABasicAnimation *pointAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pointAnim.fromValue = @0.0;
        pointAnim.toValue = @1.0;
        pointAnim.duration = newDuration;
        [_curveLineLayer addAnimation:pointAnim forKey:@"drawLine"];
        
        //图层直线的轨迹
        UIBezierPath *path = [UIBezierPath bezierPath];
#warning 起始点似乎有问题
        [path moveToPoint:CGPointMake(-_widthGrid*2, 0)];
        [path addLineToPoint:CGPointMake(_yReplicatorLayer.frame.size.width, 0)];
        _progressLayer.path = path.CGPath;
        _progressLayer.strokeEnd = 0.0;
        //动画时间
        CGFloat duration = newDuration * (_sumLineWidth/_yReplicatorLayer.frame.size.width);
        //进度程度
        CGFloat progress = 1.0;
        //strokeEnd 动画到某个点结束
        CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animate.removedOnCompletion = NO;
        animate.fillMode = kCAFillModeForwards;
        animate.duration = duration;
        animate.fromValue = @0.0;
        animate.toValue = @(progress);
        //为图层添加动画
        [_progressLayer addAnimation:animate forKey:@"drawProgress"];
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
    btn.layer.borderColor = _curvePointColor.CGColor;
    btn.layer.borderWidth = 2.0;
    btn.tag = index;
    btn.backgroundColor = [UIColor whiteColor];
    
    [_mainView addSubview:btn];
    [btn addTarget:self action:@selector(_pointAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)_pointAction:(UIButton *)btn{
    NSString *number = [NSString stringWithFormat:@"%@",_valueData[btn.tag][JHChartViewY]];
    _numberLabel.text = number;
    _numberLabel.hidden = NO;
    _numberLabel.alpha = 0;
    CGSize size = [number sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
    
    _numberLabel.frame = CGRectMake(_numberLabel.frame.origin.x,_numberLabel.frame.origin.y,size.width+8, size.height);
    _numberLabel.center = CGPointMake(btn.center.x, btn.center.y-10);
    [UIView animateWithDuration:1 animations:^{
        _numberLabel.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    NSLog(@"%@",number);
}

-(UILabel *)YunitLabel{
    if (!_YunitLabel) {
        _YunitLabel = [UILabel new];
        _YunitLabel.textColor = _titlesColor;
        _YunitLabel.font = [UIFont systemFontOfSize:10];
        _YunitLabel.backgroundColor = [UIColor whiteColor];
    }
    return _YunitLabel;
}
-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _numberLabel.backgroundColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = _curveLineColor;
        _numberLabel.layer.cornerRadius = 3;
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.font = [UIFont systemFontOfSize:10];
        _numberLabel.layer.borderColor = _curveLineColor.CGColor;
        _numberLabel.layer.borderWidth = 0.5;
        //        _numberLabel.hidden = YES;
    }
    return  _numberLabel;
}
/**
 绘制数字显示label
 */
-(void)_creatNumberLabels{
    for (int i = 0; i<_pointData.count; i++) {
        NSString *number = [NSString stringWithFormat:@"%@",_valueData[i][JHChartViewY]];
        if ([number integerValue] ==0 ) {
            continue;
        }
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_mainView addSubview:numberLabel];
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = _curveLineColor;
        numberLabel.layer.cornerRadius = 3;
        numberLabel.layer.masksToBounds = YES;
        numberLabel.font = [UIFont systemFontOfSize:10];
        numberLabel.layer.borderColor = kBaseLineColor.CGColor;
        numberLabel.layer.borderWidth = 0.5;
        numberLabel.text = number;
        CGSize size = [number sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        
        numberLabel.frame = CGRectMake(numberLabel.frame.origin.x,numberLabel.frame.origin.y,size.width+8, size.height);
        //根据数据切换上下位置
        CGPoint btnCenter = [[_pointData objectAtIndex:i] CGPointValue];
        //根据end_YPos判断label显示在圆环上面或下面
        CGFloat end_YPos;
        
        if (i == 0) {//当前圆环是第一个时i
            end_YPos = btnCenter.y;
        }else{//当前圆环不是第一个时
            CGPoint preCenter = [[_pointData objectAtIndex:i-1] CGPointValue];
            end_YPos = preCenter.y - btnCenter.y;
        }
        
        //根据end_YPos，设置popoverLabel的上下位置
        if (end_YPos < 0) {
            numberLabel.center = CGPointMake(btnCenter.x, btnCenter.y+12);
            
        }else{
            
            numberLabel.center = CGPointMake(btnCenter.x, btnCenter.y-12);
        }
    }
    
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
//    NSAssert(_XTitles.count ==_valueData.count, @"x坐标文本数量必须与x值数量相同");
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
        for (int i = 0; i<_numberY+1; i++) {
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
//    [self _layout];
//    [self _creatXLabels];
//    [self _creatYLabels];
//    [self _drawPath];
    
}
-(void)JHMenuBtnDidSelectBtn:(NSInteger)index{
    _chartBlock(index);
}

/**
 滚动到能够显示今天居中为止
 */
-(void)scrollShowDoday{
    CGFloat x = (_currentDate-1)*_widthGrid+_spaceWidth;
    if (x>(3*_widthGrid+_spaceWidth)) {
        if (x>(_XTitles.count-3-1)*_widthGrid+_spaceWidth) {
            x = (_XTitles.count-3-1)*_widthGrid+_spaceWidth;
        }
        //中间偏移量为3*_widthGrid
        _scrollView.contentOffset = CGPointMake(x-3*_widthGrid, 0);
    }
    
    
}
@end
