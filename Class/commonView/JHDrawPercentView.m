//
//  JHDrawPersentView.m
//  JHChartViewTest
//
//  Created by hyjt on 2017/8/7.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHDrawPercentView.h"
const static float progressHeight = 5;
@interface JHDrawPercentView ()
//显示动画的View
@property (nonatomic,strong) UIView *animationView;
//渐变图层
@property (nonatomic,strong) CALayer *gradientLayer;
//轨迹图层
@property (nonatomic,strong) CAShapeLayer *progressLayer;

//渐变颜色图层
@property (nonatomic,strong) CAGradientLayer *gradientColorLayer;

@end

@implementation JHDrawPercentView

- (instancetype)initWithFrame:(CGRect)frame withPercent:(CGFloat )persent
{
    self = [super initWithFrame:frame];
    if (self) {
        self.percent = persent;
        self.animationTime = 1.0;
        self.startColor = [UIColor cyanColor];
        self.endColor = [UIColor blueColor];
        self.progressBackGroundColor = [UIColor lightGrayColor];
        [self _creatSubView];

    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.percent = 1.0;
    self.animationTime = 1.0;
    self.startColor = [UIColor cyanColor];
    self.endColor = [UIColor blueColor];
    self.progressBackGroundColor = [UIColor lightGrayColor];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self layout];
}
-(void)_creatSubView{
    [self addSubview:self.animationView];
    //将渐变图层添加到animationView的图层上
    [self.animationView.layer addSublayer:self.gradientLayer];
    [self.gradientLayer addSublayer:self.gradientColorLayer];
    //用progressLayer来截取渐变层
    [self.gradientLayer setMask:self.progressLayer];

    [self.percentView addSubview:self.labPercent];
    [self.percentView bringSubviewToFront:self.labPercent];
    [self addSubview:self.percentView];
}

/**
 百分比标签
 */
-(UIView *)percentView{
    if (!_percentView) {
        _percentView = [UIView new];
        
    }
    return _percentView;
}
-(UILabel *)labPercent{
    if (!_labPercent) {
        _labPercent = [UICountingLabel new];
        _labPercent.textAlignment = NSTextAlignmentCenter;
        _labPercent.textColor = [UIColor whiteColor];
        _labPercent.layer.masksToBounds = NO;
        _labPercent.format = @"击败了%d%%";
        _labPercent.font = [UIFont systemFontOfSize:10];
    }
    return _labPercent;
}
/**
 动画主视图
 */
-(UIView *)animationView{
    if (!_animationView) {
        _animationView = [UIView new];
        _animationView.layer.cornerRadius = progressHeight/2;
        _animationView.backgroundColor = _progressBackGroundColor;
    }
    return _animationView;
    
}

/**
 渐变图层
 */
- (CALayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CALayer layer];
    }
    return _gradientLayer;
}
-(CAGradientLayer *)gradientColorLayer{
    if (!_gradientColorLayer) {
        _gradientColorLayer = [CAGradientLayer layer];
        [_gradientColorLayer setColors:[NSArray arrayWithObjects:(id)_startColor.CGColor,(id)_endColor.CGColor, nil]];
        //渐变方向水平
        [_gradientColorLayer setStartPoint:CGPointMake(0, 1)];

    }
    return _gradientColorLayer;
}

/**
 进度遮罩图层
 */
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        CGFloat lineWidth = progressHeight;
        
        _progressLayer = [CAShapeLayer layer];
        
        _progressLayer.lineWidth = lineWidth*2;
        _progressLayer.lineCap = kCALineCapSquare;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        //将路径填充颜色设置为透明
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _progressLayer;
}

/**
 布局结构
 */
-(void)layout{

    _animationView.frame = CGRectMake(0, self.frame.size.height-progressHeight, self.frame.size.width, progressHeight);
    _gradientLayer.frame = CGRectMake(0, 0, _animationView.frame.size.width, _animationView.frame.size.height);
    _gradientColorLayer.frame = CGRectMake(0, 0, _animationView.frame.size.width, _animationView.frame.size.height);
    _gradientColorLayer.cornerRadius = _gradientLayer.frame.size.height/2;
    _percentView.frame = CGRectMake(0, 0, 60, 20);
    _labPercent.frame = CGRectMake(0, 0, 60, 15);
    
    [self drawTriangle];
    [self _privateAnimation];
}


/**
 绘制向下的三角形（这里的路径超出了Label，当然我们只要不截取超出部分就行了，不用管原始Label中的文字是否居中）
 */
-(void)drawTriangle{
    //圆角矩形
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_labPercent.frame cornerRadius:3];
    //三角形
    UIBezierPath *trianglePath = [[UIBezierPath alloc] init];
    [trianglePath moveToPoint:CGPointMake(_percentView.frame.size.width/2-2, _percentView.frame.size.height-5)];;
    [trianglePath addLineToPoint:CGPointMake(_percentView.frame.size.width/2, _percentView.frame.size.height)];
    [trianglePath addLineToPoint:CGPointMake(_percentView.frame.size.width/2+2, _percentView.frame.size.height-5)];
    //扩展绘制路径
    [path appendPath:trianglePath];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillColor = kBaseColor.CGColor;
    //必须将他添加到最下一层，否则会遮挡其他图层
    //    [_labPercent.layer addSublayer:fillLayer];
    [_labPercent.layer insertSublayer:fillLayer atIndex:0];
}

/**
 开启动画
 */
-(void)_privateAnimation{
    
    //图层直线的轨迹
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(_animationView.frame.size.width, 0)];
    _progressLayer.path = path.CGPath;

    self.progressLayer.strokeEnd = 0.0;
    //动画时间
    CGFloat duration = _animationTime;
    //进度程度
    CGFloat progress = _percent;
    //strokeEnd 动画到某个点结束
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animate.removedOnCompletion = NO;
    animate.fillMode = kCAFillModeForwards;
    animate.duration = duration;
    animate.fromValue = @0.0;
#warning 存在偏差，目前不知道原因
    animate.toValue = @(progress-0.02);
    //为图层添加动画
    [self.progressLayer addAnimation:animate forKey:@"anim1"];
    
    //百分比标签动画（iOS 10失效？？？）
     _percentView.center = CGPointMake(0, _percentView.center.y);
#warning 此处使用延迟，使动画生效了
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:_animationTime animations:^{
            
            _percentView.center = CGPointMake(self.frame.size.width*_percent, _percentView.center.y);
        }];
    });

    [_labPercent countFromZeroTo:_percent*100 withDuration:_animationTime];
    
}

/**
 点用这个方法添加子视图，执行动画
 */
-(void)_animate{
    [self _creatSubView];
}


@end
