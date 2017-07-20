//
//  NSString+MD5.h
//  JH_PasswordDesign
//
//  Created by hyjt on 16/9/30.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

+ (NSString *)stringToMD5:(NSString *)str;
/**
 文件MD5值
 */
+(NSString*)fileMD5:(NSString*)path;
@end
