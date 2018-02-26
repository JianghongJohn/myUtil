//
//  UIFont+Change.m
//  zsxc
//
//  Created by hyjt on 2017/8/9.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "UIFont+Change.h"
//#import <objc/message.h>
@implementation UIFont (Change)

//+ ()
//+ (void)load {
//    
//    Method systimeFont = class_getClassMethod(self, @selector(systemFontOfSize:));
//    
//    Method qsh_systimeFont = class_getClassMethod(self, @selector(qsh_systemFontOfSize:));
//    // 交换方法
//    method_exchangeImplementations(qsh_systimeFont, systimeFont);
//    
//}


+ (UIFont *)jh_systemFontOfSize:(CGFloat)pxSize{
    
    CGFloat pt = (pxSize/96.0)*72.0;
    
    NSLog(@"pt--%f",pt);
    
    UIFont *font = [UIFont systemFontOfSize:pt];
    
    return font;
    
}

@end
