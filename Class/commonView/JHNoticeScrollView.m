//
//  JHNoticeScrollView.m
//  JH_NoticeScrollView
//
//  Created by hyjt on 2017/8/1.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHNoticeScrollView.h"
@interface JHNoticeScrollView()
@property (nonatomic,strong) NSTimer *timer;    //定时器
@property (nonatomic,assign) NSInteger count;     //当前滚动到的位置
@property (nonatomic,assign) NSInteger flag;   //标识当前是哪个view显示(currentView/hiddenView)
@property (nonatomic,strong) NSMutableArray *dataArr;     //Model数据源
@property (nonatomic,strong) UIView *currentView;   //当前显示的view
@property (nonatomic,strong) UIView *hiddenView;     //底部藏起的view

//当前显示的内容
@property (nonatomic,strong) UILabel *currentLabel;
//未显示的内容
@property (nonatomic,strong) UILabel *hiddenLabel;

@property (nonatomic,strong) UIImageView *currentNoticeImage;
@property (nonatomic,strong) UIImageView *hiddenNoticeImage;
@end

@implementation JHNoticeScrollView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _count = 0;
    _flag = 0;
    self.backgroundColor = [UIColor yellowColor];
    self.layer.masksToBounds = YES;
    
    
    [self createCurrentView];
    [self createhiddenView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTap:)];
    [self addGestureRecognizer:tap];
    //改进
    UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
    [self addGestureRecognizer:longPress];
    
}

- (void)dealTap:(UITapGestureRecognizer *)tap
{
    if (self.clickBlock) {
        self.clickBlock(_count);
    }
}

-(void)dealLongPress:(UILongPressGestureRecognizer*)longPress{
    
    if(longPress.state==UIGestureRecognizerStateEnded){
        
        _timer.fireDate=[NSDate distantPast];
        
        
    }
    if(longPress.state==UIGestureRecognizerStateBegan){
        
        _timer.fireDate=[NSDate distantFuture];
    }
    
}

- (void)_setVerticalShowDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    JHNoticeScrollModel *model = _dataArr[_count];

    self.currentLabel.text = model.content;

}

#pragma mark - 跑马灯操作
-(void)dealTimer
{
    _count++;
    if (_count == _dataArr.count) {
        _count = 0;
    }
    
    if (_flag == 1) {
        JHNoticeScrollModel *currentModel = _dataArr[_count];
        
        self.currentLabel.text = currentModel.content;
        
    }
    
    if (_flag == 0) {
        JHNoticeScrollModel *hienModel = _dataArr[_count];
        
        self.hiddenLabel.text = hienModel.content;
        
    }
    
    
    if (_flag == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.currentView.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            _flag = 1;
            self.currentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.hiddenView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.hiddenView.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            _flag = 0;
            self.hiddenView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.width);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.currentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}


- (void)createTimer
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dealTimer) userInfo:nil repeats:YES];
}

- (void)createCurrentView
{
    JHNoticeScrollModel *model = _dataArr[_count];
    
    self.currentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.currentView];
    
    //公告图片
    self.currentNoticeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.currentNoticeImage.image = [UIImage imageNamed:@"广播"];
    self.currentNoticeImage.center = CGPointMake(30, self.currentView.frame.size.height/2);
    [self.currentView addSubview:self.currentNoticeImage];
    
    //内容标题
    self.currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, self.frame.size.width-self.currentNoticeImage.frame.size.width-30, 40)];
    self.currentLabel.center = CGPointMake(self.currentLabel.center.x, self.currentView.frame.size.height/2);
    self.currentLabel.text = model.content;
    self.currentLabel.textAlignment = NSTextAlignmentLeft;
    self.currentLabel.textColor = [UIColor redColor];
    self.currentLabel.font = [UIFont systemFontOfSize:12];
    [self.currentView addSubview:self.currentLabel];
    
    
}

- (void)createhiddenView
{
    JHNoticeScrollModel *model = _dataArr[_count];
    self.hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.hiddenView];
    //公告图片
    self.hiddenNoticeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.hiddenNoticeImage.image = [UIImage imageNamed:@"广播"];
    self.hiddenNoticeImage.center = CGPointMake(30, self.hiddenView.frame.size.height/2);
    [self.hiddenView addSubview:self.hiddenNoticeImage];
    
    //内容标题
    self.hiddenLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, self.frame.size.width-self.hiddenNoticeImage.frame.size.width-30, 40)];
    self.hiddenLabel.center = CGPointMake(self.hiddenLabel.center.x,  self.hiddenView.frame.size.height/2);
    self.hiddenLabel.text = model.content;
    self.hiddenLabel.textAlignment = NSTextAlignmentLeft;
    self.hiddenLabel.textColor = [UIColor redColor];
    self.hiddenLabel.font = [UIFont systemFontOfSize:12];
    [self.hiddenView addSubview:self.hiddenLabel];
    
    
}


#pragma mark - 开始／停止定时器

- (void)_start {
    //创建定时器
    [self createTimer];
}

- (void)_stopTimer {
    //停止定时器
    //在invalidate之前最好先用isValid先判断是否还在线程中：
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer = nil;
    }
}



@end
