//
//  JHSelectBtn.m
//  zsxc
//
//  Created by hyjt on 2017/11/14.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHSelectBtn.h"
@interface JHSelectBtn ()
@property(nonatomic,strong)UIImageView *selectImageView;
@end

@implementation JHSelectBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        self.layer.borderColor = kBasePlaceHoldColor.CGColor;
        self.layer.borderWidth = 1.0f;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self _addImage];
    }
    return self;
}
-(UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [UIImageView new];
        _selectImageView.image = [UIImage imageNamed:@"btnSelect"];
        _selectImageView.hidden = YES;
    }
    return _selectImageView;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self).multipliedBy(1.0/2);
    }];
}
/**
 添加角标
 */
-(void)_addImage{
    
    [self addSubview:self.selectImageView];
    
}
-(void)setSelected:(BOOL)selected{

    self.selectImageView.hidden = !selected;
    self.layer.borderColor = selected?kBaseColor.CGColor:kBasePlaceHoldColor.CGColor;
    [self setTitleColor:selected?kBaseColor:kBaseTitleColor forState:0];
}

@end
