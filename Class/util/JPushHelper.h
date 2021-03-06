//
//  JPushHelper.h
//  haoqibaoyewu
//
//  Created by hyjt on 16/9/13.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// 这里是iOS10需要用到的框架
#import <UserNotifications/UserNotifications.h>
#endif


#ifdef DEBUG // 开发

static BOOL const isProduction = FALSE; // 极光FALSE为开发环境

#else // 生产

static BOOL const isProduction = TRUE; // 极光TRUE为生产环境

#endif
@interface JPushHelper : NSObject 
// 在应用启动的时候调用
+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
  advertisingIdentifier:(NSString *)advertisingId;

// 在appdelegate注册设备处调用
+ (void)registerDeviceToken:(NSData *)deviceToken;

// ios7以后，才有completion，否则传nil
+ (void)handleRemoteNotificationWithApplication:(UIApplication *)application userInfo:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;

// 显示本地通知在最前面
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification;
//ios10以上
+ (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification;


+ (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response;
//处理数据
+(void)_dealWithData:(NSDictionary *)userInfo;

/**
 设置设备别名用于个人推送
 */
+(void)_setAlias;

// log NSSet with UTF8
// if not ,log will be \Uxxx
+ (NSString *)logDic:(NSDictionary *)dic;
@end
