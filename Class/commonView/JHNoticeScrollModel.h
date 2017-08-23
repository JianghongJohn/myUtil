//
//  JHNoticeScrollModel.h
//  JH_NoticeScrollView
//
//  Created by hyjt on 2017/8/1.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHNoticeScrollModel : NSObject
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)NSInteger type;//区分类型，跳转页面或者网页
@property(nonatomic,copy)NSString *urlString;
@property(nonatomic,copy)NSString *className;
@end
