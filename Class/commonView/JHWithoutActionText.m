//
//  JHWithoutActionText.m
//  zsxc
//
//  Created by hyjt on 2017/8/22.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHWithoutActionText.h"

/**
 一个静止长按动作的输入框
 */
@implementation JHWithoutActionText

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController*menuController = [UIMenuController sharedMenuController];
    
    if(menuController) {
        
        [UIMenuController sharedMenuController].menuVisible=NO;
        
    }
    
    return NO;
    
}
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    if (action == @selector(paste:))//禁止粘贴
//        return NO;
//    if (action == @selector(select:))// 禁止选择
//        return NO;
//    if (action == @selector(selectAll:))// 禁止全选
//        return NO;
//    return [super canPerformAction:action withSender:sender];
//}

@end
