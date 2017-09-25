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
+(void)_loadBaseDataWithApi:(NSString *)Api withFileName:(NSString *)name{
    
    NSDictionary *baseData = @{
                               };
    
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
@end
