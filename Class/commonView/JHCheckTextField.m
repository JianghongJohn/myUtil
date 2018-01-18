//
//  JHCheckTextField.m
//  JH_TextViewTest
//
//  Created by hyjt on 2017/8/17.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHCheckTextField.h"

@implementation JHCheckTextField

-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    switch (self.type) {
        case JHTextViewTypeNumber:
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case JHTextViewTypeVin:
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.limitLength = 17;
            break;
        case JHTextViewTypeCellphone:
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.limitLength = 11;
            break;
        case JHTextViewTypeIdCard:
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.limitLength = 18;
            break;
        case JHTextViewTypeNormal:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case JHTextViewTypetel:
            self.keyboardType = UIKeyboardTypePhonePad;
            break;
        case JHTextViewTypeLabel:
            self.enabled = NO;
            break;
        default:
            break;
    }
}
- (void)textFieldDidChange:(UITextField *)textField
{
        if (textField.text.length > self.limitLength&&self.limitLength!=0) {
            textField.text = [textField.text substringToIndex:self.limitLength];
        }
    if (self.type==JHTextViewTypeVin||self.type==JHTextViewTypeIdCard) {
        textField.text = textField.text.uppercaseString;
        if (self.limitLength == textField.text.length) {
            _textBlock(textField.text);
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.type==JHTextViewTypeVin||self.type==JHTextViewTypeIdCard) {
        if (self.limitLength == textField.text.length) {
            //由于在输入的时候做了验证，这里就不在返回
            return;
        }
    }
    if (textField.text.length==0) {
        _textBlock(nil);
    }else{
        _textBlock(textField.text);
    }
    
}
@end
