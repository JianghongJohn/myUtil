//
//  JHNoticeBaseView.h
//  JH_NoticeScrollView
//
//  Created by hyjt on 2017/8/3.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUM_LABELS 2
enum AutoScrollDirection {
    AUTOSCROLL_SCROLL_RIGHT,
    AUTOSCROLL_SCROLL_LEFT,
};
@protocol JHNoticeViewDelegate <NSObject>
-(void)_noticeViewDidTouched;

@end

@interface JHNoticeBaseView : UIView<UIScrollViewDelegate>{
    
    UILabel *label[NUM_LABELS];
    enum AutoScrollDirection scrollDirection;//滚动方向
    float scrollSpeed;//滚动速度
    NSTimeInterval pauseInterval; //暂停时间
    int bufferSpaceBetweenLabels;
    bool isScrolling; //判断是否正在滚动
    UIScrollView *_JHNoticeView;//滚动图
    UIImageView *_imageView;
}
@property(nonatomic,weak)id<JHNoticeViewDelegate>delegate;
@property(nonatomic) enum AutoScrollDirection scrollDirection;
@property(nonatomic) float scrollSpeed;
@property(nonatomic) NSTimeInterval pauseInterval;
@property(nonatomic) int bufferSpaceBetweenLabels;
// normal UILabel properties
@property(nonatomic,retain) UIColor *textColor;
@property(nonatomic, retain) UIFont *font;

- (void) readjustLabels;
- (void) setText: (NSString *) text;
- (NSString *) text;
- (void) scroll;

@end
