//
//  JH_CommonInterface.m
//  carFinance
//
//  Created by hyjt on 2017/4/12.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JH_CommonInterface.h"

@implementation JH_CommonInterface
/**
 加载本地存储基础数据
 */
+(void)_loadBaseDataWithApi:(NSString *)Api withFileName:(NSString *)name withForbidden:(BOOL)forbidden{
    
    NSDictionary *baseData = @{
                               };
    if (!forbidden) {
        baseData = @{
                     @"forbidden":@"0"
                     };
    }
    NSDictionary *tempData = [JH_NetWorking addBaseKeyWithData:baseData isLogin:YES];
    //添加sign
    NSString *sign = [JH_NetWorking Md5Param:tempData isLogin:YES];
    
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc] initWithDictionary:tempData];
    [requestData setObject:sign forKey:@"sign"];
    
    [JH_NetWorking requestData:[kBaseUrlStr stringByAppendingString:Api] HTTPMethod:HttpMethodPost showHud:NO params:requestData completionHandle:^(id result) {
        if ([result[@"error"]isEqual:@1]) {
            [JHDownLoadFile addDictionaryToLocal:name data:result[@"rows"]];
        }else{
            
        }
        
    } errorHandle:^(NSError *error) {
        
    }];
}
/**
 根据贷款银行获取产品类型
 */
+(void)_loadProductByBankId:(NSString *)bankId withForbidden:(BOOL)forbidden withHandle:(void(^)())handle{
    
    NSDictionary *baseData = @{
                               @"bankId":bankId
                               };
    if (!forbidden) {
        baseData = @{
                     @"bankId":bankId,
                     @"forbidden":@"0"
                     };
    }
    NSDictionary *tempData = [JH_NetWorking addBaseKeyWithData:baseData isLogin:YES];
    //添加sign
    NSString *sign = [JH_NetWorking Md5Param:tempData isLogin:YES];
    
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc] initWithDictionary:tempData];
    [requestData setObject:sign forKey:@"sign"];
    
    [JH_NetWorking requestData:[kBaseUrlStr stringByAppendingString:UTF8Char(ZSXC_api_order_product.urlString)] HTTPMethod:ZSXC_api_order_product.httpMethod showHud:NO params:requestData completionHandle:^(id result) {
        if ([result[@"error"]isEqual:@1]) {
            [JHDownLoadFile addDictionaryToLocal:kProductType data:result[@"rows"]];
            handle();
        }else{
            
        }
    } errorHandle:^(NSError *error) {
        
    }];
}
/**
 切换产品类型的时候重置年限
 */
+(void)_changeProductWithBankId:(NSString *)bankId withProductId:(NSString *)productId WithHandle:(void(^)())handle{
    
    NSDictionary *baseData = @{
                               @"bankId":bankId,
                               @"productId":productId
                               };
    
    NSDictionary *tempData = [JH_NetWorking addBaseKeyWithData:baseData isLogin:YES];
    //添加sign
    NSString *sign = [JH_NetWorking Md5Param:tempData isLogin:YES];
    
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc] initWithDictionary:tempData];
    [requestData setObject:sign forKey:@"sign"];
    
    [JH_NetWorking requestData:[kBaseUrlStr stringByAppendingString:UTF8Char(ZSXC_api_order_loanMonth.urlString)] HTTPMethod:ZSXC_api_order_loanMonth.httpMethod showHud:NO params:requestData completionHandle:^(id result) {
        if ([result[@"error"]isEqual:@1]) {
            //获取对应的产品年限并置空
            [JHDownLoadFile addDictionaryToLocal:kAgeLimit data:result[@"rows"]];
            handle();
            
        }else{
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:result[@"message"] view:nil];
            
        }
        
    } errorHandle:^(NSError *error) {
        
    }];
    
}
//从资源包中加载不会占内存
+(UIImage *)LoadImageFromBundle:(NSString *)imageName{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName
                                                     ofType:nil];
    
    return [UIImage imageWithContentsOfFile:path];
}
/**
 根据value返回数组中对应的位置
 
 @param value 相对应的id
 @return 返回数组位置
 */
+(NSInteger )getIndexOfTypeArray:(NSArray *)array dicKey:(NSString *)dicKey value:(NSString *)value{
    if (array.count<1||[array isKindOfClass:[NSDictionary class]]) {
        return -1;
    }
    //遍历array
    for (int i = 0; i<array.count;i++ ) {
        //获取数组中的value
        NSDictionary *dic = array[i];
        
        NSString *thisValue = [NSString stringWithFormat:@"%@",dic[dicKey]];
        if ([thisValue isEqualToString:[NSString stringWithFormat:@"%@",value]]) {
            return i;
        }
        
         
    }
    return -1;
}
/**
 获取当前视图

 @return UIViewController
 */
+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
/**
 获取viewController
 */
+(UIViewController *)viewController :(UIResponder *)response{
    
    UIResponder *next = response.nextResponder;
    while(next !=nil){
        if([next isKindOfClass:[UIViewController class]]){
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

/**
 获取keyWindows
 */
+(UIWindow *)getKeyWindows{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}
#define MAX_IMAGE_WH JHSCREENWIDTH/2
/*
 判断图片长度&宽度
 
 */
+(CGSize)imageShowSize:(UIImage *)image{
    
    CGFloat imageWith=image.size.width;
    CGFloat imageHeight=image.size.height;
    
    //宽度大于高度
    if (imageWith>=imageHeight) {
        // 宽度超过标准宽度
        /*
         if (imageWith>MAX_IMAGE_WH) {
         
         }else{
         
         }
         */
        
        
        return CGSizeMake(MAX_IMAGE_WH, imageHeight*MAX_IMAGE_WH/imageWith);
        
        
    }else{
        /*
         if (imageHeight>MAX_IMAGE_WH) {
         
         }else{
         
         }
         */
        
        
        return CGSizeMake(imageWith*MAX_IMAGE_WH/imageHeight, MAX_IMAGE_WH);
        
    }

    return CGSizeZero;
}

/**
 APP运行时统一跳转

 @param pageId pageid
 @param nav nav
 */
+(void)_jumpWithPageId:(NSString *)pageId withNav:(UINavigationController *)nav{
    //ClassName
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"analyseDic" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *pagesDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSString *pageIdStr = pageId;
    NSString *className = pagesDic[pageIdStr];
    if (className) {
        //特殊处理我的订单，征信，战报，审核
            if ([pageId isEqualToString:@"zsxc_report"]) {//战报
                [JH_RuntimeTool runtimePush:className dic:@{@"isSingle":@1} nav:nav];
            }else if ([pageId isEqualToString:@"zsxc_audit"]){//审核
                [JH_RuntimeTool runtimePush:className dic:@{@"isCheck":@1} nav:nav];
            }else if ([pageId isEqualToString:@"zsxc_order_list"]){//订单
                [JH_RuntimeTool runtimePush:@"CFBaseTabBarController" dic:@{@"selectIndex":@1} nav:nav];
            }else if ([pageId isEqualToString:@"zsxc_credit_list"]){//征信
                [JH_RuntimeTool runtimePush:@"CFBaseTabBarController" dic:@{@"selectIndex":@0} nav:nav];
            }else{
                [JH_RuntimeTool runtimePush:className dic:nil nav:nav];
            }
    }
    
}

/**
 获取数组中最长的文字并返回
 
 @param datas 数组（字符）
 @return 长度
 */
+(float)_getStringMaxSize:(NSArray<NSString *> *)datas{
    CGFloat maxSize = 0.0f;
    
    for (NSString *text in datas) {
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
        if (size.width>maxSize) {
            maxSize = size.width;
        }
    }
    return maxSize;
    
}

/**
 财务换审核

 @param orderId 订单编号
 */
+ (void)_changeAuditWithOrderId:(NSString *)orderId withHandle:(void (^)(void))handle{
    //换审核
    NSDictionary *baseData = @{
                               @"orderId":orderId
                               };
    
    NSDictionary *tempData = [JH_NetWorking addBaseKeyWithData:baseData isLogin:YES];
    //添加sign
    NSString *sign = [JH_NetWorking Md5Param:tempData isLogin:YES];
    
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc] initWithDictionary:tempData];
    [requestData setObject:sign forKey:@"sign"];
    
    [JH_NetWorking requestData:[kBaseUrlStr stringByAppendingString:UTF8Char(ZSXC_api_order_money_cashCheck_audit_cancel.urlString)] HTTPMethod:ZSXC_api_order_money_cashCheck_audit_cancel.httpMethod showHud:NO params:requestData completionHandle:^(id result) {
        if ([result[@"error"]isEqual:@1]) {
            
        }else{
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:result[@"message"] view:nil];
            
        }
        handle();
    } errorHandle:^(NSError *error) {
        handle();
    }];
}
@end
