//
//  JH_SDImageView.m
//  掌上行车
//
//  Created by hyjt on 2017/7/20.
//
//

#import "JH_SDImageView.h"
#define loadImage @"p1.jpg"
#define failedImage @"p1.jpg"
@implementation JH_SDImageView

/**
 根据网络地址获取图片

 @param url 地址
 */
-(void)setImageWithUrl:(NSString *)url{
    [self sd_setShowActivityIndicatorView: YES];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:loadImage] options:SDWebImageHighPriority completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image==nil) {
            self.image = [UIImage imageNamed:failedImage];
        }
        
    }];
    
    
}

@end
