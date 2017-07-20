//
//  JH_SDImageView.h
//  掌上行车
//
//  Created by hyjt on 2017/7/20.
//
//

#import <UIKit/UIKit.h>
#import <UIView+WebCache.h>
@interface JH_SDImageView : UIImageView

/**
 根据网络地址获取图片
 
 @param url 地址
 */
-(void)setImageWithUrl:(NSString *)url;
@end
