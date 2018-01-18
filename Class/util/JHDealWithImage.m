//
//  JHDealWithImage.m
//  zsxc
//
//  Created by hyjt on 2018/1/11.
//  Copyright © 2018年 haoyungroup. All rights reserved.
//

#import "JHDealWithImage.h"

@implementation JHDealWithImage
+(NSDictionary *)dealImage:(UIImage *)image withImageNames:(NSString *)imageFileName size:(CGFloat )size{
    NSData *imageData;
    @try {
        if ([imageFileName containsString:@"heic"]||[imageFileName containsString:@"HEIC"]) {
            imageFileName = [NSString stringWithFormat:@"%@.jpg",[imageFileName componentsSeparatedByString:@"."][0]];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    if (imageFileName==nil) {
        //获取时间戳和当前图片index给图片命名
        NSDate* dat = [NSDate date];
        
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
        imageFileName = [NSString stringWithFormat:@"%@.jpg",timeString];
    }
    
    imageData = [UIImage compressOriginalImageOnece:image toMaxDataSizeKBytes:size];
    NSDictionary *upData = @{@"fileData":imageData?imageData:[UIImage compressOriginalImageOnece:image toMaxDataSizeKBytes:size],
               @"name":@"file",
               @"fileName":imageFileName,
               @"mimeType":@"image/jpeg"
               };
    return upData;
}
+(NSString *)dealHeicImageName:(NSString *)imageName{
    @try {
        if ([imageName containsString:@"heic"]||[imageName containsString:@"HEIC"]) {
            imageName = [NSString stringWithFormat:@"%@.jpg",[imageName componentsSeparatedByString:@"."][0]];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return imageName;
}
@end
