//
//  NSDictionary+getValueWithCheck.m
//  zsxc
//
//  Created by hyjt on 2018/1/19.
//  Copyright © 2018年 haoyungroup. All rights reserved.
//

#import "NSDictionary+getValueWithCheck.h"

@implementation NSDictionary (getValueWithCheck)

-(id)getValueWithCheck:(NSString *)key{
    if ([self objectForKey:key]) {
        return [self objectForKey:key];
    }else{
        return @"";
    }
    
}

/**
 往字典中加入字段

 @param key 键
 @param value 值（需要判断的）
 */
-(void)setValueWithCheck:(NSString *)key value:(id)value{
    [self setValue:[NSString nullDefultString:value null:@""] forKey:key];
}
@end
