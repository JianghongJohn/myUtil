//
//  JHMenuBtn.m
//  zsxc
//
//  Created by hyjt on 2017/12/4.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHMenuBtn.h"

@implementation JHMenuBtn

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = kBaseLineColor.CGColor;
        self.layer.borderWidth = 1.0f;
        self.datas = titles;
        [self _creatBtnWithTitles:titles];
    }
    return self;
}


/**
 创建按钮
 */
-(void)_creatBtnWithTitles:(NSArray *)titles{
    CGFloat space = 1.0f;
    CGFloat btnWidth = (self.frame.size.width-(space*titles.count-1))/titles.count;
    for (int index = 0; index<titles.count; index++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((btnWidth+space)*index, 0, btnWidth, self.frame.size.height)];
        [btn setTitle:titles[index] forState:0];
        [btn setTitleColor:kBaseTextColor forState:0];
        [btn setTitleColor:kBaseColor forState:UIControlStateSelected];
        if (index==self.selectIndex) {
            btn.selected = YES;
        }
        btn.tag = index+100;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(_touchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        //添加分割线(最后一个不需要)
        if (index == titles.count-1) {
            break;
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(btnWidth+space*index, 0, space, self.frame.size.height)];
        lineView.backgroundColor = kBaseLineColor;
        [self addSubview:lineView];
    }
    
}

/**
 按钮点击
 */
-(void)_touchAction:(UIButton *)btn{
    NSInteger index = btn.tag-100;
    if (index != self.selectIndex) {
        if ([self.delegate respondsToSelector:@selector(JHMenuBtnDidSelectBtn:)]) {
            [self.delegate JHMenuBtnDidSelectBtn:index];
        }
    }
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    if (_selectIndex!=selectIndex) {
        _selectIndex = selectIndex;
        for (int i = 0; i<_datas.count; i++) {
            UIButton *button = [self viewWithTag:100+i];
            if (button.tag-100 == _selectIndex) {
                button.selected = YES;
                continue;
            }
            button.selected = NO;
        }
    }
}


@end
