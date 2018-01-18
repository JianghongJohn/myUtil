//
//  JH_ImageViewer.h
//  zsxc
//
//  Created by hyjt on 2017/8/19.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JH_ImageViewer : UIView
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *imageUrlArray;
@property(nonatomic,assign)NSInteger imageIndex;

/**
 展示已下载图片

 @param imageArray 已有图片数组
 @param imageIndex 当前位置默认为0
 */
-(void)showImageWithImageArray:(NSArray *)imageArray withIndex:(NSInteger)imageIndex;
/**
 展示网络图片
 
 @param imageUrlArray 网络图片数组
 @param imageIndex 当前位置默认为0
 */
-(void)showImageWithImageUrlArray:(NSArray *)imageUrlArray withIndex:(NSInteger)imageIndex;
@end
