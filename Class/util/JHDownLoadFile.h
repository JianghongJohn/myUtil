//
//  JHDownLoadFile.h
//  carFinance
//
//  Created by hyjt on 2017/4/20.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHDownLoadFile : NSObject
/**
 初始化下载数据
 */
+(void)_loadBaseData;
/**
 将数据添加到本地
 */
+(void)addDictionaryToLocal:(NSString *)key data:(NSArray *)data;
/**
 获取数据json字典,并添加到本地
 @param resullt block
 */
+(void)getDicByKey:(NSString *)key :(void(^)(id result))resullt;
/**
 数据字典专属根据id查找页面展示的方法
 
 @param key 数据字典类型
 @param dicId id
 @return 描述
 */
+(NSString *)getDictionTextByKey:(NSString *)key withId:(NSString *)dicId;

/**
 根据key将数据返回

 @return nsarray
 */
+(NSArray *)getArrayByKey:(NSString *)key;
/**
 路径拼接
 
 @param key 文件名
 @return 完整路劲
 */
+(NSString *)getPathByKey:(NSString *)key;
@end
