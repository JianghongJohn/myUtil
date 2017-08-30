//
//  JHBirthPickerView.h
//  NIM
//
//  Created by chris on 15/7/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionHandler)(NSString *birth);

@protocol JHBirthPickerViewDelegate <NSObject>

- (void)didSelectBirth:(NSString *)brith;

@end

@interface JHBirthPickerView : UIView

@property (nonatomic,weak) id<JHBirthPickerViewDelegate> delegate;

- (void)refreshWithBrith:(NSString *)birth;

- (void)showWithCompletion:(CompletionHandler) handler;

@end
