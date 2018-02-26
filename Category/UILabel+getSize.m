//
//  UILabel+getSize.m
//  zsxc
//
//  Created by hyjt on 2017/11/22.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "UILabel+getSize.h"

@implementation UILabel (getSize)

/**
 获取文字的自适应宽度
 */
-(CGFloat)getSize{
    //key的内容
    NSString *contentKey = self.text;
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin;
    
    NSDictionary *attrDic = @{
                              NSFontAttributeName:self.font,
                              };
    
    CGRect rect2 = [contentKey boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:options attributes:attrDic context:nil];
    
//    NSLog(@"keylabel --> rect.width = %f",rect2.size.width);
    
    CGFloat keyLabelWidth = rect2.size.width;
    
    //修改宽度约束
    return keyLabelWidth + 1;
}
@end
