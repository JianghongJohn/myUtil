//
//  ZSXCTwoActionView.h
//  zsxc
//
//  Created by hyjt on 2018/1/9.
//  Copyright © 2018年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZSXCTwoActionViewDelegate <NSObject>
-(void)ZSXCTwoActionViewSelectWithTag:(NSInteger )tag;
@end
/**
 底部统一的两个按钮（掌上行车专用）
 */
@interface ZSXCTwoActionView : UIView
@property(nonatomic,weak)id <ZSXCTwoActionViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withImages:(NSArray *)images;

@end
