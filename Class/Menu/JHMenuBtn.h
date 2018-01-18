//
//  JHMenuBtn.h
//  zsxc
//
//  Created by hyjt on 2017/12/4.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JHMenuBtnDelegate <NSObject>

-(void)JHMenuBtnDidSelectBtn:(NSInteger )index;
@end


/**
 几个按钮从左往右排的视图，选中为其他颜色
 */
@interface JHMenuBtn : UIView
@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,weak)id<JHMenuBtnDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;
@end
