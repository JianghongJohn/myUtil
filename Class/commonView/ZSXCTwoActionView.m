//
//  ZSXCTwoActionView.m
//  zsxc
//
//  Created by hyjt on 2018/1/9.
//  Copyright © 2018年 haoyungroup. All rights reserved.
//

#import "ZSXCTwoActionView.h"

@implementation ZSXCTwoActionView

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withImages:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _creatBtnViewWithTitles:titles withImages:images];
    }
    return self;
}
/**
 混合按钮
 */
-(void)_creatBtnViewWithTitles:(NSArray *)titles withImages:(NSArray *)images{
    UIView *btnView = [UIView new];
    [self addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(self.height));
    }];
    //两个按钮
    UIButton *rejectBtn = [UIButton new];
    [btnView addSubview:rejectBtn];
    [rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(btnView);
        make.width.equalTo(btnView).multipliedBy(1.0/3);
    }];
    NSString *title1 = [NSString stringWithFormat:@" %@",titles[0]];
    [rejectBtn setTitle:title1 forState:0];
    [rejectBtn setTitleColor:kBaseColor forState:0];
    [rejectBtn setImage:[UIImage imageNamed:images[0]] forState:0];
    [rejectBtn setBackgroundColor:[UIColor whiteColor]];
    rejectBtn.tag = 100;
    [rejectBtn addTarget:self action:@selector(_submit:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *submitBtn = [UIButton new];
    [btnView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(btnView);
        make.width.equalTo(btnView).multipliedBy(2.0/3);
    }];
    NSString *title2 = [NSString stringWithFormat:@" %@",titles[1]];
    [submitBtn setTitle:title2 forState:0];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:0];
    [submitBtn setImage:[UIImage imageNamed:images[1]] forState:0];
    [submitBtn setBackgroundColor:kBaseColor];
    submitBtn.tag = 101;
    [submitBtn addTarget:self action:@selector(_submit:) forControlEvents:UIControlEventTouchUpInside];
    
}
/**
 提交
 */
-(void)_submit:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(ZSXCTwoActionViewSelectWithTag:)]) {
        [self.delegate ZSXCTwoActionViewSelectWithTag:btn.tag];
    }
}
@end
