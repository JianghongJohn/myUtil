//
//  JHTextView.m
//  JH_TextViewTest
//
//  Created by hyjt on 2017/7/17.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHTextView.h"
#import "JHCheckUtil.h"
@implementation JHTextView
#pragma mark - system (systemMethod override)
-(instancetype)_initWithFrame:(CGRect)frame{
    return [self _initWithFrame:frame withType:JHTextViewTypeNormal withCheckType:JHTextViewCheckTypeNone withLimitLength:0 withAllowedEdit:YES];
    
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.type        = JHTextViewTypeNormal;
    self.checkType   = JHTextViewCheckTypeNone;
    self.limitLength = 0;
    self.allowedEdit = YES;
    //        self.backgroundColor = [UIColor lightGrayColor];
   
}
-(void)layoutSubviews{
    [super layoutSubviews];
     [self _creatTextView];
}
#pragma mark - UI (creatSubView and layout)
/**
 初始化创建输入框
 
 @param type 输入框文本类型
 @param checkType 文本验证类型
 @param limitLength 限制长度
 @param allowedEdit 是否允许编辑
 */
-(instancetype)_initWithFrame:(CGRect )frame withType:(JHTextViewType )type withCheckType:(JHTextViewCheckType )checkType withLimitLength:(NSUInteger)limitLength withAllowedEdit:(BOOL)allowedEdit{
    self = [super initWithFrame:frame];
    if (self) {
        self.type        = type;
        self.checkType   = checkType;
        self.limitLength = limitLength;
        self.allowedEdit = allowedEdit;
//        self.backgroundColor = [UIColor lightGrayColor];
//        [self _creatTextView];
    }
    return self;
}
-(instancetype)_initWithFrame:(CGRect)frame withType:(JHTextViewType)type withCheckType:(JHTextViewCheckType)checkType{
    return [self _initWithFrame:frame withType:type withCheckType:checkType withLimitLength:0 withAllowedEdit:YES];
}


/**
 textViewAttribute
 */
-(void)_creatTextView{
    
    if (!_jhTextView) {
        
        _jhTextView = ({
            UITextView *text = [[UITextView alloc] init];
            text.font = [UIFont systemFontOfSize:15];
            text.layer.cornerRadius = 5;
            text.layer.borderWidth = 0.5;
            text.layer.borderColor = [UIColor lightGrayColor].CGColor;
            text.delegate = self;
            text;
        });
        _jhTextView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_jhTextView];
    }
    if (!self.allowedEdit) {
        _jhTextView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _jhTextView.editable = NO;
    }
    //图标展示对错
    NSLayoutConstraint *right;
    

    if (self.checkType==JHTextViewCheckTypeCheck) {
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-35, 0, 30, 30)];
        _checkImageView.center = CGPointMake(_checkImageView.center.x, self.frame.size.height/2);
        _checkImageView.image = [UIImage imageNamed:@"error"];
        [self addSubview:_checkImageView];
        right = [NSLayoutConstraint constraintWithItem:_jhTextView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-40.0];
    }else{
        right = [NSLayoutConstraint constraintWithItem:_jhTextView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5.0];
    }
    
    //layout1
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_jhTextView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5.0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_jhTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_jhTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0];
    [self addConstraint:left];
    [self addConstraint:right];
    [self addConstraint:top];
    [self addConstraint:bottom];
    
    
    
}

#pragma mark - delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    
    
    NSString *textString = textView.text;
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    //限制输入字数
    if (self.limitLength>0) {
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (textString.length > self.limitLength)
            {
                NSRange rangeIndex = [textString rangeOfComposedCharacterSequenceAtIndex:self.limitLength];
                if (rangeIndex.length == 1)
                {
                    textView.text = [textString substringToIndex:self.limitLength];
                }
                else
                {
                    NSRange rangeRange = [textString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitLength)];
                    textView.text = [textString substringWithRange:rangeRange];
                }
            }
        }
        
    }
    //当为判断红色边框类型的时候
    //停止编辑的时候需要将数据返回
    if (self.checkType==JHTextViewCheckTypeRed) {
        //手机号提示
        if (self.type==JHTextViewTypeCellphone) {
            if (![JHCheckUtil checkTelNumber:textView.text]) {
                self.jhTextView.layer.borderColor = [UIColor redColor].CGColor;
                
//                NSLog(@"输入手机号错误");
            }else{
                self.jhTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                
            }
            
        }else if (self.type==JHTextViewTypeIdCard) {
            //身份证提示
            if (![JHCheckUtil checkUserIdCard:textView.text]) {
//                NSLog(@"输入身份证号错误");
                self.jhTextView.layer.borderColor = [UIColor redColor].CGColor;
                
            }else{
                self.jhTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                
            }
            
        }
    }else if (self.checkType==JHTextViewCheckTypeCheck) {
        //手机号提示
        if (self.type==JHTextViewTypeCellphone) {
            if (![JHCheckUtil checkTelNumber:textView.text]) {
                self.checkImageView.image = [UIImage imageNamed:@"error"];
                //                NSLog(@"输入手机号错误");
            }else{
                self.checkImageView.image = [UIImage imageNamed:@"right"];
                
            }
            
        }else if (self.type==JHTextViewTypeIdCard) {
            //身份证提示
            if (![JHCheckUtil checkUserIdCard:textView.text]) {
                //                NSLog(@"输入身份证号错误");
                self.checkImageView.image = [UIImage imageNamed:@"error"];
            }else{
                self.checkImageView.image = [UIImage imageNamed:@"right"];
                
            }
            
        }

    }

}
-(void)textViewDidEndEditing:(UITextView *)textView{
    //停止编辑的时候需要将数据返回
    if (self.checkType==JHTextViewCheckTypeAlert) {
        //手机号提示
        if (self.type==JHTextViewTypeCellphone) {
            if (![JHCheckUtil checkTelNumber:textView.text]) {
                [self _alertWithString:@"手机号格式错误！"];
            }
            
        }else if (self.type==JHTextViewTypeIdCard) {
            //身份证提示
            if (![JHCheckUtil checkUserIdCard:textView.text]) {
                [self _alertWithString:@"身份证格式错误！"];
            }
            
        }
    }
}
#pragma mark - utilMethod
/**
 弹出提示
 */
-(void)_alertWithString:(NSString *)text{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
    
    
}
-(UIViewController *)viewController{
    UIResponder *response = self.nextResponder;
    while (![response isKindOfClass:[UIViewController class]]) {
        response = response.nextResponder;
    }
    return (UIViewController *)response;
}
-(void)setPlaceHold:(NSString *)placeHold{
    if (_placeHold!=placeHold) {
        _placeHold = placeHold;
        [self _setupPlaceHold];
    }
}
- (void)_setupPlaceHold
{
    //_placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = _placeHold;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.font = _jhTextView.font;;
    
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [_jhTextView addSubview:placeHolderLabel];
    [_jhTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
}



-(void)setType:(JHTextViewType)type{
    if (_type!=type) {
        _type = type;
        [self _creatTextView];
    }
    
}
-(void)setCheckType:(JHTextViewCheckType)checkType{
    if (_checkType!=checkType) {
        _checkType=checkType;
        [self _creatTextView];
    }
}
-(void)setAllowedEdit:(BOOL)allowedEdit{
    if (_allowedEdit!=allowedEdit) {
        _allowedEdit = allowedEdit;
        [self _creatTextView];
    }
}

-(void)setLimitLength:(NSUInteger)limitLength{
    if (_limitLength!=limitLength) {
        _limitLength = limitLength;
        [self _creatTextView];
    }
}
@end
