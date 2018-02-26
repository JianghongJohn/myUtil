//
//  NSDictionary+getValueWithCheck.h
//  zsxc
//
//  Created by hyjt on 2018/1/19.
//  Copyright © 2018年 haoyungroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (getValueWithCheck)

/**
 获取字典的value并校验key是否存在

 @param key 字典key
 @return 字典值
 */
-(id)getValueWithCheck:(NSString *)key;

/**
 往字典中加入字段
 
 @param key 键
 @param value 值（需要判断的）
 */
-(void)setValueWithCheck:(NSString *)key value:(id)value;
@end
