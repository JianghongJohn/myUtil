//
//  JHDealWithImage.h
//  zsxc
//
//  Created by hyjt on 2018/1/11.
//  Copyright © 2018年 haoyungroup. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 处理图片数据
 */
@interface JHDealWithImage : NSObject
+(NSDictionary *)dealImage:(UIImage *)image withImageNames:(NSString *)imageFileName size:(CGFloat )size;
+(NSString *)dealHeicImageName:(NSString *)imageName;
@end
