//
//  JHButtonMenuCell.h
//  zsxc
//
//  Created by hyjt on 2017/8/7.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHButtonMenuModel.h"
@interface JHButtonMenuCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCenterView;
@property (weak, nonatomic) IBOutlet UILabel *labNumber;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;


@property(nonatomic,strong)JHButtonMenuModel *model;
@end
