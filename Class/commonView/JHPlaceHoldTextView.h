//
//  JHPlaceHoldTextView.h
//  zsxc
//
//  Created by hyjt on 2017/10/17.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPlaceHoldTextView : UITextView
typedef void (^JHPlaceHoldTextViewBlock) (NSString * _Nullable text);
@property(nonatomic,strong)JHPlaceHoldTextViewBlock _Nullable textBlock;
@property (assign, nonatomic) BOOL neededBack;

@property (copy, nonatomic)NSString * _Nullable jh_placeholder;

@property (strong, nonatomic, nullable) IBInspectable UIColor *jh_placeholderColor;

@property (strong, nonatomic, nullable) UIFont *jh_placeholderFont;
@property (assign, nonatomic) NSInteger jh_limitLength;
@end
