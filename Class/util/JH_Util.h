//
//  JH_Util.h
//  haoqibaoyewu
//
//  Created by hyjt on 16/7/19.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JH_Util : NSObject
+ (NSString *)htmlShuangyinhao:(NSString *)values;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
//处理空字符
+ (NSString *) nullDefultString: (NSString *)fromString null:(NSString *)nullStr;

#pragma 正则匹配邮箱号
+ (BOOL)checkMailInput:(NSString *)mail;
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号15位
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹配用户身份证号18位
+(BOOL)verifyIDCardNumber:(NSString *)value;
#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
#pragma 正则匹配网页URL
+ (BOOL)checkWebURL : (NSString *) url;
#pragma 正则匹配昵称
+ (BOOL) checkNickname:(NSString *) nickname;
#pragma 正则匹配以C开头的18位字符
+ (BOOL) checkCtooNumberTo18:(NSString *) nickNumber;
#pragma 正则匹配以C开头字符
+ (BOOL) checkCtooNumber:(NSString *) nickNumber;
#pragma 正则匹配银行卡号是否正确
+ (BOOL) checkBankNumber:(NSString *) bankNumber;
#pragma 正则匹配17位车架号
+ (BOOL) checkCheJiaNumber:(NSString *) CheJiaNumber;
#pragma 正则只能输入数字和字母
+ (BOOL) checkTeshuZifuNumber:(NSString *) CheJiaNumber;
#pragma 车牌号验证
+ (BOOL) checkCarNumber:(NSString *) CarNumber;
#pragma 根据cityCode获取省份简称
+ (NSString *) getProVinceShortFromCode:(NSString *)code;
#pragma 对比两个时间的大小
+ (BOOL) compareTimeWithToday:(NSString *)time;

@end
