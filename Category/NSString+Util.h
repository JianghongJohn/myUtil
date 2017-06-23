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
@end
