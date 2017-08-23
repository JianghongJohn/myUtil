//
//  JHButtonMenuView.h
//  zsxc
//
//  Created by hyjt on 2017/8/7.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHButtonMenuCell.h"
@interface JHButtonMenuView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSArray *menuData;
//init
-(id)initWithFrame:(CGRect)frame withData:(NSArray *)data;
@end
