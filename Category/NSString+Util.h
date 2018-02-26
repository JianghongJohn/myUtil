//
//  NSString+Util.h
//  carFinance
//
//  Created by hyjt on 2017/6/11.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)
/**
 验证数据正确性
 
 @param data 目前为字符串
 @return YES则通过验证
 */
+(BOOL )isCorrectData:(NSString *)data;
/**
 字符转NSDecimalNumber加法计算
 */
+(NSString *)calculateDecimalNumberWithValue:(NSString *)string1 value2:(NSString *)string2;
/**
 数据类型格式化显示123,123.123
 @param number 输入（可能是string也可能是number）
 @return 格式化字符
 */
+(NSString *)numberFormat:(id)number;
/**
 替换空字符(后面为替换字符)
 */
+ (NSString *) nullDefultString: (NSString *)fromString null:(NSString *)nullStr;
/**
 给string添加红色*作为前缀
 */
+(NSMutableAttributedString *)addNeedSymbol:(NSString *)text;
/**
 字典转json的类别
 */
+(NSString*)DataTOjsonString:(id)object;
/**
 字典转json并去除空格和换行
 */
+(NSString*)DataTOjsonStringWithoutSpace:(id)object;

/**
 给字符串MD5加密
 */
+ (NSString *)stringToMD5:(NSString *)str;
/**
 文件MD5值
 */
+(NSString*)fileMD5:(NSString*)path;

@end
