//
//  JHPlaceHoldTextView.m
//  zsxc
//
//  Created by hyjt on 2017/10/17.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHPlaceHoldTextView.h"

@interface JHPlaceHoldTextView ()<UITextViewDelegate>

@property (weak, nonatomic) UILabel *placeholderLabel;

@end

@implementation JHPlaceHoldTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self setUp];
    return self;
}

- (void)setUp {
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderLabel = placeholderLabel];
    
    self.delegate = self;
    self.jh_placeholderColor = [UIColor lightGrayColor];
    self.jh_placeholderFont = [UIFont systemFontOfSize:16.0f];
    self.font = [UIFont systemFontOfSize:16.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

/**
 文字改变

 @param textView 限制长度
 */
-(void)textViewDidChange:(UITextView *)textView{
    
    
    NSString *textString = textView.text;
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    //限制输入字数
    if (self.jh_limitLength>0) {
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (textString.length > self.jh_limitLength)
            {
                NSRange rangeIndex = [textString rangeOfComposedCharacterSequenceAtIndex:self.jh_limitLength];
                if (rangeIndex.length == 1)
                {
                    textView.text = [textString substringToIndex:self.jh_limitLength];
                }
                else
                {
                    NSRange rangeRange = [textString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.jh_limitLength)];
                    textView.text = [textString substringWithRange:rangeRange];
                }
            }
        }
        
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_neededBack) {
        _textBlock(textView.text);
    }
}
#pragma mark - UITextViewTextDidChangeNotification

- (void)textDidChange {
    BOOL hidden = self.hasText;
    self.placeholderLabel.hidden = hidden;
}


- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}


- (void)setJh_placeholderFont:(UIFont *)jh_placeholderFont {
    _jh_placeholderFont = jh_placeholderFont;
    self.placeholderLabel.font = jh_placeholderFont;
    [self setNeedsLayout];
}

- (void)setJh_placeholder:(NSString *)jh_placeholder {
    _jh_placeholder = [jh_placeholder copy];
    
    self.placeholderLabel.text = jh_placeholder;
    
    [self setNeedsLayout];
    
}


- (void)setJh_placeholderColor:(UIColor *)jh_placeholderColor {
    _jh_placeholderColor = jh_placeholderColor;
    self.placeholderLabel.textColor = jh_placeholderColor;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.placeholderLabel.frame;
    frame.origin.y = self.textContainerInset.top;
    frame.origin.x = self.textContainerInset.left+6.0f;
    frame.size.width = self.frame.size.width - self.textContainerInset.left*2.0;
    
    CGSize maxSize = CGSizeMake(frame.size.width, MAXFLOAT);
    frame.size.height = [self.jh_placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    self.placeholderLabel.frame = frame;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}

@end
