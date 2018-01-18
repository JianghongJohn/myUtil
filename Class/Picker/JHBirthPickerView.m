//
//  JHBirthPickerView.m
//  NIM
//
//  Created by chris on 15/7/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "JHBirthPickerView.h"
#import "UIViewExt.h"
#import "NSString+ChangeTime.h"
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
#define JHBrithMinYear 1900
#define JHBrithMAXYear [[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian]components:NSCalendarUnitYear fromDate:[NSDate date]].year

static const CGFloat kButtonHeight = 40.0f;
static const CGFloat kButtonWidth = 75.0f;
#define kpickerHeight [UIScreen mainScreen].bounds.size.height/3
@interface JHBirthPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,copy) CompletionHandler handler;

@property (nonatomic,strong) NSDateFormatter *formateter;

@property (nonatomic,strong) NSCalendar *calendar;
/** 背景图片 */
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *btnBgView;
/** button */
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *certainButton;
@end

@implementation JHBirthPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //backGround
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.pickerView];
        [self _creatButton];

        _formateter = [[NSDateFormatter alloc] init];
        [_formateter setDateFormat:@"yyyy-MM-dd"];
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return self;
}
-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        _backgroundView.alpha = 0;
    }
    return  _backgroundView;
}
-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height+kButtonHeight,self.frame.size.width, kpickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _pickerView.delegate   = self;
        _pickerView.dataSource = self;
        
    }
    return _pickerView;
}
-(void)_creatButton{
    
    _btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height,kButtonWidth, kButtonHeight)];
    _btnBgView.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
//    _btnBgView.alpha = 0.7;
    [self addSubview:_btnBgView];
    
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,kButtonWidth, kButtonHeight)];
    [_btnBgView addSubview:_cancelButton];
    [_cancelButton setTitle:@"取消" forState:0];

    [_cancelButton setTitleColor:kBaseColor forState:0];
    
    //    _cancelButton.alpha = 0.7;
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _certainButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-kButtonWidth,0,kButtonWidth, kButtonHeight)];
    [_btnBgView addSubview:_certainButton];
    [_certainButton setTitle:@"确定" forState:0];

    [_certainButton setTitleColor:kBaseColor forState:0];
    //    _certainButton.alpha = 0.7;
    [_certainButton addTarget:self action:@selector(dismissWithCallback) forControlEvents:UIControlEventTouchUpInside];
}
//touch remove
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.backgroundView];
    if (!CGRectContainsPoint(self.pickerView.frame, point))
    {
        [self dismiss];
    }
}

/**
 默认选中的时间

 @param birth 传入之前的时间展示
 */
- (void)refreshWithBrith:(NSString *)birth{
    if (![self isVaildBirth:birth]) {
        //默认使用当前时间的年月日
        NSTimeInterval time =  [[NSDate date] timeIntervalSince1970];
        NSString *nowTime = [NSString changeTimeIntervalToDate:@(time)];
        birth = nowTime;
    }
    if ([birth isKindOfClass:[NSString class]]) {
        NSDate* date = [self.formateter dateFromString:birth];
        if (date) {
            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
            NSInteger year  = components.year - JHBrithMinYear > 0? components.year - JHBrithMinYear : 0;
            NSInteger month = components.month - 1 > 0? components.month - 1 : 0;
            NSInteger day   = components.day - 1 > 0? components.day - 1 : 0;
            [self.pickerView selectRow:year inComponent:0 animated:NO];
            [self.pickerView selectRow:month inComponent:2 animated:NO];
            [self.pickerView selectRow:day inComponent:4 animated:NO];
        }
    }

}
- (void)showWithCompletion:(CompletionHandler) handler{
    
    // 在主线程中处理,否则在viewDidLoad方法中直接调用,会先加本视图,后加控制器的视图到UIWindow上,导致本视图无法显示出来,这样处理后便会优先加控制器的视图到UIWindow上
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundView.alpha = 1.0f;
            self.pickerView.frame = CGRectMake(0, self.frame.size.height-self.pickerView.frame.size.height, self.frame.size.width, self.pickerView.frame.size.height);
            
            _btnBgView.frame = CGRectMake(0, self.frame.size.height-self.pickerView.frame.size.height-kButtonHeight,  self.frame.size.width, self.certainButton.frame.size.height);
        } completion:nil];
    }];
    self.handler = handler;
    
}
/**
 callback
 */
-(void)dismissWithCallback{
    NSString *birth = [self formateDate:self.year month:self.month day:self.day];
    if ([self.delegate respondsToSelector:@selector(didSelectBirth:)]) {
        [self.delegate didSelectBirth:birth];
    }
    if (self.handler) {
        self.handler(birth);
    }
    [self dismiss];
}
/**
 dismiss remove
 */
- (void)dismiss
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 0.0f;
        self.pickerView.frame = CGRectMake(0, self.frame.size.height+kButtonHeight, self.frame.size.width, self.pickerView.frame.size.height);
        _btnBgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.certainButton.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [pickerView reloadComponent:4];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat alpha = 0.0f;
    switch (component) {
        case 0:
            alpha = .22f;
            break;
        case 1:
            alpha = .12f;
            break;
        case 2:
            alpha = .14f;
            break;
        case 3:
            alpha = .12f;
            break;
        case 4:
            alpha = .14f;
            break;
        case 5:
            alpha = .12f;
            break;
        default:
            break;
    }
    return pickerView.width * alpha;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:         //年
            return [NSString stringWithFormat:@"%zd",row+JHBrithMinYear];
        case 1:         //小时说明文字
            return @"年";
        case 2:
            return [NSString stringWithFormat:@"%zd",row+1];
        case 3:
            return @"月";
        case 4:
            return [NSString stringWithFormat:@"%zd",row+1];
        case 5:
            return @"日";
        default:
            return @"";
    }
    
}
//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = kBaseLineColor;
        }
    }
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return JHBrithMAXYear - JHBrithMinYear + 1;//年
        case 1:
            return 1; //年说明文字
        case 2:
            return 12;//月
        case 3:
            return 1; //月说明文字
        case 4:
            return [self daysInMonth:self.month year:self.year];
        case 5:
            return 1; //日说明文字
        default:
            return 0;
    }
}


#pragma mark - Private
- (NSInteger)year{
    return JHBrithMinYear + [self.pickerView selectedRowInComponent:0];
}

- (NSInteger)month{
    return [self.pickerView selectedRowInComponent:2] + 1;
}

- (NSInteger)day{
    return [self.pickerView selectedRowInComponent:4] + 1;
}

- (NSInteger)daysInMonth:(NSInteger)month year:(NSInteger)year{
    NSString *formatedDate = [self formateDate:year month:month day:1];
    NSDate* date = [self.formateter dateFromString:formatedDate];
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

- (NSString *)formateDate:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    return [NSString stringWithFormat:@"%zd-%02zd-%02zd",year,month,day];
}

- (BOOL)isVaildBirth:(NSString *)birth{
    if ([birth isKindOfClass:[NSString class]]) {
        NSDate* date = [self.formateter dateFromString:birth];
        if (date) {
            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
            NSInteger year  = components.year;
            return year >= JHBrithMinYear && year <= JHBrithMAXYear;
        }
    }
    return NO;
}

@end
