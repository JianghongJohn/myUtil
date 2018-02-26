//
//  NSString+Util.m
//  carFinance
//
//  Created by hyjt on 2017/6/11.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Util)

/**
 验证数据正确性

 @param data 目前为字符串
 @return YES则通过验证
 */
+(BOOL )isCorrectData:(NSString *)data{
    if (!data||[data isKindOfClass:[NSNull class]]||[data isEqualToString:@""]||[data isEqualToString:@"(null)"] || [data isEqualToString:@"<null>"] || [data isEqualToString:@"null"]) {
        return NO;
    }
    return YES;
}
/**
 字符转NSDecimalNumber加法计算
 */
+(NSString *)calculateDecimalNumberWithValue:(NSString *)string1 value2:(NSString *)string2{
    if ([string1 isKindOfClass:[NSNumber class]]) {
        string1  = [NSString stringWithFormat:@"%@",string1];
    }
    if ([string2 isKindOfClass:[NSNumber class]]) {
        string2  = [NSString stringWithFormat:@"%@",string2];
    }
    NSDecimalNumber *value1 = [NSDecimalNumber decimalNumberWithString:string1?string1:@"0"];
    NSDecimalNumber *value2 = [NSDecimalNumber decimalNumberWithString:string2?string2:@"0"];
    NSDecimalNumber *addValue = [value1 decimalNumberByAdding:value2];
    return [NSString stringWithFormat:@"%@",addValue];
}
/**
 数据类型格式化显示123,123.123
 @param number 输入（可能是string也可能是number）
 @return 格式化字符
 */
+(NSString *)numberFormat:(id)number{
    NSString *formatString;
    @try {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterDecimalStyle;
        [formatter setPositiveFormat:@"###,##0.00"];
        NSNumber *numberFromString;
        if ([number isKindOfClass:[NSString class]]) {
            numberFromString =  [formatter numberFromString:number];
        }else{
            numberFromString = number;
        }
        formatString = [formatter stringFromNumber:numberFromString];
    } @catch (NSException *exception) {
        return @"";
    } @finally {
        return formatString;
    }
}
/**
 替换空字符(后面为替换字符)
 */
+ (NSString *) nullDefultString: (NSString *)fromString null:(NSString *)nullStr{
    if ([fromString isKindOfClass:[NSNumber class]]) {
        return fromString;
    }
    if ([fromString isKindOfClass:[NSNull class]]) {
        return nullStr;
    }
    if (fromString == nil) {
        return nullStr;
    }
    if ([fromString isEqualToString:@"(null)"] || [fromString isEqualToString:@"<null>"] || [fromString isEqualToString:@"null"] || [fromString isEqualToString:@""]) {
        return nullStr;
    }else{
        return fromString;
    }
}
/**
 给string添加红色*作为前缀
 */
+(NSMutableAttributedString *)addNeedSymbol:(NSString *)text{
    if (![text containsString:@"*"]) {
        text = [NSString stringWithFormat:@"*%@",text];
    }
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
    [attribute setAttributes:@{NSForegroundColorAttributeName :[UIColor redColor]} range:NSMakeRange(0, 1)];
    return attribute;
}
/**
 字典转json的类别
 */
+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
/**
 字典转json并去除空格和换行
 */
+(NSString*)DataTOjsonStringWithoutSpace:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    return mutStr;
}
/**
 字符串加密
 */
+ (NSString *)stringToMD5:(NSString *)str
{
    //0给字符串加盐
    //    str = [str stringByAppendingString:@"弘哥"];
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}

/**
 文件MD5值
 */
#define CHUNK_SIZE 1024*8
+(NSString*)fileMD5:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: CHUNK_SIZE ];
        CC_MD5_Update(&md5, [fileData bytes], (uint32_t)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}


@end
