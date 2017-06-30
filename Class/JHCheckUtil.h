//
//  JHCheckUtil.h
//  carFinance
//
//  Created by hyjt on 2017/4/19.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCheckUtil : NSObject
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard;
/**
 输入框中只能输入数字和小数点，且小数点只能输入一位，参数number 可以设置小数的位数，该函数在-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string调用；
 */
+ (BOOL)isValidAboutInputText:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string decimalNumber:(NSInteger)number;
@end
