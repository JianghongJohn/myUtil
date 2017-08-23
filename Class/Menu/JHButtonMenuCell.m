//
//  JHButtonMenuCell.m
//  zsxc
//
//  Created by hyjt on 2017/8/7.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHButtonMenuCell.h"

@implementation JHButtonMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(JHButtonMenuModel *)model{
    if (_model != model) {
        _model = model;
        
        self.imgCenterView.image = [UIImage imageNamed:_model.imageName];
        self.labTitle.text = _model.title;
        self.labNumber.hidden = [_model.number integerValue]==0;
        self.labNumber.text = _model.number;
    }
    
}
@end
