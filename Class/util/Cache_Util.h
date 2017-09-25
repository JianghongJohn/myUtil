//
//  Cache_Util.h
//  haoqibaoyewu
//
//  Created by hyjt on 16/9/23.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache_Util : NSObject
#pragma mark - 获取缓存大小
+(CGFloat )getCacheSize;
#pragma mark - 清除缓存
+(void)clearCache;
#pragma mark - 获取设备内存大小

@end
