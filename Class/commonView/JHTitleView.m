//
//  JHTitleView.m
//  zsxc
//
//  Created by hyjt on 2017/10/23.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHTitleView.h"

@implementation JHTitleView

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *whiteView = [UIView new];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 0, 0, 0));
        }];
        //蓝色标记
        UIView *markView = [UIView new];
        markView.backgroundColor = kBaseColor;
        [whiteView addSubview:markView];
        [markView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView).with.offset(15);
            make.centerY.equalTo(whiteView);
            make.height.equalTo(whiteView).multipliedBy(0.4);
            make.width.equalTo(@3);
        }];
        //文字
        UILabel *label  = [UILabel new];
        [whiteView addSubview:label];
        label.textColor = kBaseTitleColor;
        label.font = [UIFont systemFontOfSize:15];
        label.text = title;
            if ([label.text containsString:@"*"]) {
                label.attributedText = [NSString addNeedSymbol:title];
            }
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(markView.mas_right).with.offset(8);
            make.centerY.equalTo(markView);
        }];
    }
    return self;
}

@end
