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
加载本地存储基础数据
*/
+(void)_loadBaseDataWithApi:(NSString *)Api withFileName:(NSString *)name;
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

@end
