//
//  JHPickerImageView.m
//  carFinance
//
//  Created by hyjt on 2017/4/14.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHPickerImageView.h"
#import "JH_ImagePickerSheet.h"
#import "UIImage+Draw.h"
@interface JHPickerImageView()
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UILabel *labTip;
@end
@implementation JHPickerImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addTapGesture];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self _addTapGesture];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithPatternImage:[self bgImage]];
    self.deleteBtn.frame = CGRectMake(self.width-30, 0, 30, 30);
    UIImage *addImage = [UIImage imageNamed:@"button_add"];
    self.labTip.frame    = CGRectMake(0, CGRectGetHeight(self.bounds)/2+addImage.size.height/2, CGRectGetWidth(self.bounds), 30);
}
//绘制出添加按钮的背景
-(UIImage *)bgImage{
    UIImage *image1 = [UIImage imageWithColor:[UIColor whiteColor] withRect:self.bounds];
    UIImage *image2 = [UIImage imageNamed:@"button_add"];
    return  [UIImage combineWithFirstImage:image2 secondImage:image1 byRect:self.bounds];
    
}
-(UILabel *)labTip{
    if (!_labTip) {
        
        _labTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _labTip.textColor = [UIColor lightGrayColor];
        _labTip.font = [UIFont systemFontOfSize:15];
        _labTip.textAlignment = NSTextAlignmentCenter;
    }
    return _labTip;
}
//设置显示的文字和删除的提示文字
-(void)setText:(NSString *)text{
    if (_text!=text) {
        _text = text;
    }
    self.labTip.text = [NSString stringWithFormat:@"请上传%@",_text];
}
/**
 创建单机事件
 */
-(void)_addTapGesture{

    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapAction)];
    [self addGestureRecognizer:tap];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.labTip];
}
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_deleteBtn setImage:[UIImage imageNamed:@"button_del"] forState:0];
        [_deleteBtn addTarget:self action:@selector(_deleImageAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.hidden = YES;
    }
    return  _deleteBtn;
}

-(void)setPicture:(UIImage *)image{
    if (image!=nil&&![image isKindOfClass:[NSNull class]]) {
        if (self.image!=image) {
            self.image = image;
        }
        self.deleteBtn.hidden = NO;
        self.labTip.hidden = YES;
    }
}
-(void)_deleImageAction{
    NSString *title = self.text?[NSString stringWithFormat:@"确认删除%@?",self.text]:@"确认删除该照片？";
    [JHAlertControllerTool alertTitle:@"提示" mesasge:title preferredStyle:1 confirmHandler:^(UIAlertAction *action) {
        _block(_indexPath,YES);
        self.image = nil;
        self.deleteBtn.hidden = YES;
        self.labTip.hidden = NO;
    } cancleHandler:^(UIAlertAction *action) {
        
    } viewController:[JH_CommonInterface viewController:self]];
    
}
/**
 点击之后的动作
 */
-(void)_tapAction{
    if (self.deleteBtn.hidden) {
        _block(_indexPath,NO);
        //直接跳转
        JH_ImagePickerSheet *sheet = [[JH_ImagePickerSheet alloc] init];
        [sheet _setImagePickerForClass:[JH_CommonInterface viewController:self] canEditing:NO];
    }
    
}

@end
