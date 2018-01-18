//
//  JHCheckTextField.h
//  JH_TextViewTest
//
//  Created by hyjt on 2017/8/17.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JHTextViewType) {
    JHTextViewTypeNormal = 0,
    JHTextViewTypeCellphone = 1 <<0,//值为2的0次方
    JHTextViewTypeIdCard  = 1 <<1,//值为2的1次方
    JHTextViewTypeVin  = 1 <<2,
    JHTextViewTypeNumber  = 1 <<3,
    JHTextViewTypetel  = 1 <<4,
    JHTextViewTypeLabel  = 1 <<5
};
typedef void (^TextFieldBlock) (NSString *text);
@interface JHCheckTextField : UITextField<UITextFieldDelegate>
@property(nonatomic,copy)NSString *placeHold;
@property(assign,nonatomic)JHTextViewType type;
@property(assign,nonatomic)BOOL allowedEdit;
@property(assign,nonatomic)NSUInteger limitLength;
@property(nonatomic,strong)TextFieldBlock textBlock;
@end
