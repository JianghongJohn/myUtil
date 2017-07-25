//
//  JHTextView.h
//  JH_TextViewTest
//
//  Created by hyjt on 2017/7/17.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JHTextViewType) {
    JHTextViewTypeNormal = 0,
    JHTextViewTypeCellphone = 1 <<0,//值为2的0次方
    JHTextViewTypeIdCard  = 1 <<1,//值为2的1次方
    JHTextViewTypeVin  = 1 <<2
};
typedef NS_ENUM(NSInteger, JHTextViewCheckType) {
    JHTextViewCheckTypeNone = 0,
    JHTextViewCheckTypeAlert = 1 <<0,
    JHTextViewCheckTypeCheck  = 1 <<1,
    JHTextViewCheckTypeRed  = 1 <<2
};
/**
 我需要一个输入框控件满足
 1.首先要有一个边框 √
 2.能够限制输入行数，且多行时根据宽度自动换行 √
 3.能够传入类型（手机号、身份证号、车架号等），自动校验数据 √
 4.数据校验应该有多种方式（1.弹出框（结束编辑），2.右侧绿色打钩小箭头（实时验证），3.输入框边框颜色由红色变成普通）√
 5.限制输入长度，长度大于则限制输入（采用文字截取的方法）√
 6.可开启是否允许编辑，不可编辑应该输入框背景变灰 √
 */
@interface JHTextView : UIView<UITextViewDelegate>
@property(nonatomic,strong)UITextView *jhTextView;
@property(nonatomic,strong)UIImageView *checkImageView;
@property(nonatomic,copy)NSString *placeHold;
@property(assign,nonatomic)JHTextViewType type;
@property(assign,nonatomic)JHTextViewCheckType checkType;
@property(assign,nonatomic)BOOL allowedEdit;
@property(assign,nonatomic)NSUInteger limitLength;
/**
 初始化创建输入框

 @param type 输入框文本类型
 @param checkType 文本验证类型
 @param limitLength 限制长度
 @param allowedEdit 是否允许编辑
 */
-(instancetype)_initWithFrame:(CGRect )frame withType:(JHTextViewType )type withCheckType:(JHTextViewCheckType )checkType withLimitLength:(NSUInteger)limitLength withAllowedEdit:(BOOL)allowedEdit;
-(instancetype)_initWithFrame:(CGRect )frame withType:(JHTextViewType )type withCheckType:(JHTextViewCheckType )checkType;
-(instancetype)_initWithFrame:(CGRect )frame;
@end
