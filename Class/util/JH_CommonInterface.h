//
//  JH_CommonInterface.h
//  carFinance
//
//  Created by hyjt on 2017/4/12.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
@interface JH_CommonInterface : NSObject

/**
加载本地存储基础数据(yes则为全部查询状态)
*/
+(void)_loadBaseDataWithApi:(NSString *)Api withFileName:(NSString *)name withForbidden:(BOOL)forbidden;
/**
 根据贷款银行获取产品类型
 */
+(void)_loadProductByBankId:(NSString *)bankId withForbidden:(BOOL)forbidden withHandle:(void(^)())handle;
/**
 切换产品类型的时候重置年限
 */
+(void)_changeProductWithBankId:(NSString *)bankId withProductId:(NSString *)productId WithHandle:(void(^)())handle;
//从资源包中加载不会占内存
+(UIImage *)LoadImageFromBundle:(NSString *)imageName;
/**
 根据value返回数组中对应的位置
 
 @param value 相对应的id
 @return 返回数组位置
 */
+(NSInteger )getIndexOfTypeArray:(NSArray *)array dicKey:(NSString *)dicKey value:(NSString *)value;
/**
 获取当前视图
 
 @return UIViewController
 */
+ (UIViewController *)presentingVC;

/**
 获取viewController
 */
+(UIViewController *)viewController :(UIResponder *)response;

/*
 判断图片长度&宽度
 
 */
+(CGSize)imageShowSize:(UIImage *)image;
/**
 APP运行时统一跳转
 
 @param pageId pageid
 @param nav nav
 */
+(void)_jumpWithPageId:(NSString *)pageId withNav:(UINavigationController *)nav;

/**
 获取数组中最长的文字并返回

 @param datas 数组（字符）
 @return 长度
 */
+(float)_getStringMaxSize:(NSArray<NSString *> *)datas;
/**
 财务换审核
 
 @param orderId 订单编号
 */
+ (void)_changeAuditWithOrderId:(NSString *)orderId withHandle:(void (^)(void))handle;
@end
