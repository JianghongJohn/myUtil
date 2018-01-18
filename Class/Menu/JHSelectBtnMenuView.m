//
//  JHSelectBtnMenuView.m
//  zsxc
//
//  Created by hyjt on 2017/11/14.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHSelectBtnMenuView.h"

const static CGFloat space = 10;
@implementation JHSelectBtnMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.key = @"keyWorld";
        self.des = @"valueDesc";
    }
    return self;
}
-(void)setDatas:(NSArray<NSDictionary *> *)datas{
    if (_datas!=datas) {
        _datas = datas;
        //移除旧视图
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
//        CGFloat btnWidth = (self.frame.size.width-space*(_datas.count+1))/_datas.count;
        //绘制页面
        CGFloat width = 0.0f;
        for (NSInteger i = datas.count-1; i<datas.count; i--) {
            NSDictionary *data = _datas[i];
            NSString *title = data[self.des];
            CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
            CGFloat btnWidth = size.width+20;
            CGFloat x = self.frame.size.width - (btnWidth +width);
            JHSelectBtn *btn = [[JHSelectBtn alloc]initWithFrame:CGRectMake(x, 0, size.width+20, 30)];
            //当前视图占用宽度
            width = space + width + btnWidth;
            [self addSubview:btn];
            btn.center = CGPointMake(btn.center.x, self.height/2);
            btn.tag = 100+i;
            btn.selected = NO;
            [btn addTarget:self action:@selector(_btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
        }
    }
    
}

/**
 设置选中，防止贼刷新的时候，使选中状态消失
 @param selectValue 值
 */
-(void)setSelectValue:(NSString *)selectValue{
    if (_selectValue!=selectValue) {
        _selectValue = selectValue;
        
    }
    for (int i = 0; i<_datas.count; i++) {
        NSDictionary *data = _datas[i];
        JHSelectBtn *button = [self viewWithTag:100+i];
        if ([data[_key] isEqualToString:_selectValue]) {
            button.selected = YES;
            continue;
        }
        button.selected = NO;
    }
}
/**
 点击，并将对应的数据返回

 @param btn JHSelectBtn
 */
-(void)_btnAction:(JHSelectBtn *)btn{
    if (_notAllowedSelect) {
        if ([self.delegate respondsToSelector:@selector(_JHSelectBtnMenuViewDidSelectBtn:WithKey:withDes:)]) {
            [self.delegate _JHSelectBtnMenuViewDidSelectBtn:nil WithKey:nil withDes:nil];
        }
        return;
    }
    for (int i = 0; i<_datas.count; i++) {
        JHSelectBtn *button = [self viewWithTag:100+i];
        if (btn.tag == 100+i) {
            button.selected = YES;
            continue;
        }
        button.selected = NO;
    }
    NSDictionary *data = _datas[btn.tag-100];
    if ([self.delegate respondsToSelector:@selector(_JHSelectBtnMenuViewDidSelectBtn:WithKey:withDes:)]) {
        [self.delegate _JHSelectBtnMenuViewDidSelectBtn:self WithKey:data[self.key] withDes:data[self.des]];
    }
    
}
@end
