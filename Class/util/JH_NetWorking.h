//
//  JH_NetWorking.h
//  haoqibaoyewu
//
//  Created by hyjt on 16/7/22.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
typedef NS_ENUM(NSInteger ,HttpMethod) {
    HttpMethodGet,
    HttpMethodPost,
    HttpMethodDelete
};
@interface JH_NetWorking : NSObject
@property(nonatomic,strong)AFHTTPSessionManager *sessionManager;
+(JH_NetWorking *)shareNetWorking;
/**
 添加请求必备项
 */
+(NSDictionary *)addBaseKeyWithData:(NSDictionary *)data isLogin:(BOOL)isLogin;
/**
 MD5加密
 
 @param data 原始Data数据
 @return MD5字符串
 */
+(NSString *)Md5Param:(NSDictionary *)data isLogin:(BOOL)isLogin;
/**
 下载数据
 */
+(void)downloadFile:(NSString *)urlString fileName:(NSString *)fileName completionHandler:(void (^)())completionHandler;
/**
 使用普通keyvalue的网络请求
 @param urlString 完整url
 @param method 请求方法
 @param showHud 是否展示进度条
 @param params 参数
 @param completionblock 成功回调
 @param errorblock 失败回调
 */
+ (void)requestData:(NSString *)urlString HTTPMethod:(HttpMethod )method showHud:(BOOL)showHud params:(NSDictionary *)params completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock;
/**
 http网络请求（使用Json方式）
 
 @param urlString 完整url
 @param method 请求方法
 @param showHud 是否展示进度条
 @param params 参数
 @param completionblock 成功回调
 @param errorblock 失败回调
 */
+ (void)requestDataByJson:(NSString *)urlString HTTPMethod:(HttpMethod )method  showHud:(BOOL)showHud params:(NSDictionary *)params completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock;
/**
 上传附件的网络请求
 
 @param urlString 完整url
 @param method 请求方法
 @param params 参数
 @param completionblock 成功回调
 @param errorblock 失败回调
 */
+ (void)requestDataAndFormData:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock;
+ (void)requestDataAndFormDataWithNoHud:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock;
/**
 自定义安全策略
 */
+ (AFSecurityPolicy*)customSecurityPolicy;
/**
 fastfds统一删除删除文件
 */
+ (void)_deleteFileWithArray:(NSArray *)files withComplationHandle:(void(^)())completionBlock;
/**
 同步请求
 */
+(id)sendSynchronousRequest:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params;
@end
