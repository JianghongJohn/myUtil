//
//  JH_ImageViewer.m
//  zsxc
//
//  Created by hyjt on 2017/8/19.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JH_ImageViewer.h"
#import "JHImageViewerWindow.h"
@interface JH_ImageViewer ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collection;
@property(nonatomic,strong)UICollectionViewFlowLayout *flayout;

@end

@implementation JH_ImageViewer
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
    }
    return self;
}
/**
 展示已下载图片
 
 @param imageArray 已有图片数组
 @param imageIndex 当前位置默认为0
 */
-(void)showImageWithImageArray:(NSArray *)imageArray withIndex:(NSInteger)imageIndex{
    _imageArray = imageArray;
    _imageIndex = imageIndex;
    self.frame = [UIScreen mainScreen].bounds;
    [self _setOneTapGesture];
//    self.backgroundColor = [UIColor blackColor];
    //register collectionCell
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
    
    [self addSubview:self.collection];
    [self.collection setContentOffset:CGPointMake((self.bounds.size.width)*_imageIndex, 0)];
    
    [self show];
}
/**
 展示网络图片
 
 @param imageUrlArray 网络图片数组
 @param imageIndex 当前位置默认为0
 */
-(void)showImageWithImageUrlArray:(NSArray *)imageUrlArray withIndex:(NSInteger)imageIndex{
    _imageUrlArray = imageUrlArray;
    _imageIndex = imageIndex;
    self.frame = [UIScreen mainScreen].bounds;
    [self _setOneTapGesture];
    //    self.backgroundColor = [UIColor blackColor];
    //register collectionCell
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
    
    [self addSubview:self.collection];
    [self.collection setContentOffset:CGPointMake((self.bounds.size.width)*_imageIndex, 0)];
    
    [self show];
}
/**
 create Collection
 */
-(UICollectionView *)collection{
    if (!_collection ) {
        _collection                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.bounds)+10, CGRectGetHeight(self.bounds)) collectionViewLayout:self.flayout];
        _collection.pagingEnabled   = YES;
        _collection.delegate        = self;
        _collection.dataSource      = self;
//        _collection.backgroundColor = [UIColor blackColor];
    }
    
    return _collection;
}
-(UICollectionViewFlowLayout *)flayout{
    if (!_flayout) {
        _flayout                         = [[UICollectionViewFlowLayout alloc] init];
        _flayout.itemSize                = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _flayout.sectionInset            = UIEdgeInsetsMake(0, 0, 0, 10);
        _flayout.minimumInteritemSpacing = 0;
        _flayout.minimumLineSpacing      = 10;
        _flayout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        
    }
    return _flayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.imageArray?_imageArray.count:_imageUrlArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    for (UIView *view in imageCell.contentView.subviews) {
        [view removeFromSuperview];
    }
    WeakSelf
    //addImageView
    JHImageViewerWindow *imageView;
    if (self.imageArray) {
       imageView = [[JHImageViewerWindow alloc] initWithFrame:imageCell.contentView.bounds WithImage:_imageArray[indexPath.row]];

    }else{
       imageView = [[JHImageViewerWindow alloc] initWithFrame:imageCell.contentView.bounds WithImageUrl:_imageUrlArray[indexPath.row]];
    }
    [imageView setDismissBlock:^{
        [weakSelf dismiss];
    }];
    [imageCell.contentView addSubview:imageView];
    
    return imageCell;
}
#pragma -mark collectionWillShow setTitleAndIndex
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
/**
 设置单点事件
 */
-(void)_setOneTapGesture{
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:_tap];
}
-(void)show{
    // 在主线程中处理,否则在viewDidLoad方法中直接调用,会先加本视图,后加控制器的视图到UIWindow上,导致本视图无法显示出来,这样处理后便会优先加控制器的视图到UIWindow上
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
-(void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
