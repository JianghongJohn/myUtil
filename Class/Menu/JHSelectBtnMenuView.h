//
//  JHSelectBtnMenuView.h
//  zsxc
//
//  Created by hyjt on 2017/11/14.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSelectBtn.h"

@class JHSelectBtnMenuView;
@protocol JHSelectBtnMenuViewDelegate <NSObject>

/**
 选中按钮返回数据

 @param jhSelectBtnMenuView JHSelectBtnMenuView
 @param key key
 @param des des
 */
-(void)_JHSelectBtnMenuViewDidSelectBtn:(JHSelectBtnMenuView *)jhSelectBtnMenuView WithKey:(NSString *)key withDes:(NSString *)des;
@end
/**
 出现横版排布的几个按钮，点击切换选中，并实时返回数据
 */
@interface JHSelectBtnMenuView : UIView
@property(nonatomic,strong)NSArray<NSDictionary *>*datas;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *viewId;
@property(nonatomic,copy)NSString *des;
@property(nonatomic,copy)NSString *selectValue;
@property(nonatomic,assign)BOOL notAllowedSelect;
@property(nonatomic,weak)id <JHSelectBtnMenuViewDelegate>delegate;
@end
