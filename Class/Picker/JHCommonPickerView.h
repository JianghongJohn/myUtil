//
//  JHCommonPickerView.h
//  JHCommonPickerView
//
//  Created by hyjt on 2017/4/10.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectDataBlock) (NSString *key ,NSString *description);
@interface JHCommonPickerView : UIView
@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,copy)NSString *keyValue;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray<NSDictionary *> *)titleArray handler:(SelectDataBlock)selectBlock;
-(void)show;
@end
