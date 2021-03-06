//
//  JH_SearchView.m
//  haoqibaoyewu
//
//  Created by hyjt on 16/7/21.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "JH_SearchView.h"
@interface JH_SearchView()<UISearchBarDelegate>

@end;
@implementation JH_SearchView
{
    UIButton *_searchButton;
}
/**
 自定义搜索框
 */
- (instancetype)initWithFrame:(CGRect)frame withPlaceHold:(NSString *)placehold
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.placeholder = placehold;
        //设置渲染颜色，让取消和搜索变颜色
        self.tintColor = kBaseColor;
        self.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor] withRect:frame];
        [self _DIYAttribute];
    }
    return self;
}
/**
 获取UISearchBarBackground这个视图并将其从视图中移除（灰色的背景框）
 */
-(void)_DIYAttribute{
    /**
     *  iOS7之后在SearchBar之后添加一层UIview，UIview之后才有相对应的视图子类
     */
    UITextField *searchField = [self valueForKey:@"searchField"];
    searchField.layer.cornerRadius = 5.0f;
    searchField.layer.borderColor = kBaseBGColor.CGColor;
    searchField.layer.borderWidth = 1;
    searchField.layer.masksToBounds = YES;
    searchField.backgroundColor = kBaseBGColor;
//    for (UIView *subview in self.subviews) {
//        if ([subview isKindOfClass:[UIView class]]) {
//            for (UIView *nextView in subview.subviews) {
//                
//                if ([nextView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                    [nextView removeFromSuperview];
//
//                }
//                /**
//                 *  //实验证明此位置在遍历时执行顺序在background后
//                 *  @param @"UINavigationButton"
//                 *  @return 修改系统控件
//                 */
////                if ([nextView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
////                    UIButton *button = (UIButton *)nextView;
////                    [button setTitle:@"取消" forState:0];
////                    break;
////                }
//            }
//        }
//    }
    
}
/**
 文字编辑开始
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;{
    //清空输入文字
    self.showsCancelButton = YES;
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIView class]]) {
            for (UIView *nextView in subview.subviews) {
                /**
                 *  //实验证明此位置在遍历时执行顺序在background后
                 *  @param @"UINavigationButton"
                 *  @return 修改系统控件
                 */
                if ([nextView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                    _searchButton = (UIButton *)nextView;
                    //判断是否有文字
                    if (searchBar.text.length==0) {
                        [_searchButton setTitle:@"取消" forState:0];
                    }
                    else{
                         [_searchButton setTitle:@"搜索" forState:0];
                        }
                    break;
                }
            }
        }
    }
    //实现代理
    if ([self.JHdelegate respondsToSelector:@selector(_searchTextDidBeginEditing:)]) {
        [self.JHdelegate _searchTextDidBeginEditing:self];
    }
}// called when text starts editing
/**
 文字编辑结束
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;   {
    self.showsCancelButton = NO;
    //实现代理
    if ([self.JHdelegate respondsToSelector:@selector(_searchTextDidEndEditing:)]) {
        [self.JHdelegate _searchTextDidEndEditing:self];
    }
}
/**
 监控输入文字变化，改变取消与搜索状态
 */

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{

    //判断是否有文字
    if (searchBar.text.length==0) {
        [_searchButton setTitle:@"取消" forState:0];
    }else{
        if (![_searchButton.titleLabel.text isEqualToString:@"搜索"]) {
            
            [_searchButton setTitle:@"搜索" forState:0];
        }
    }
    //实现代理
    if ([self.JHdelegate respondsToSelector:@selector(_searchTextDidChange:)]) {
        [self.JHdelegate _searchTextDidChange:self];
    }
    
    
}
/**
 点击键盘的搜索按钮
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;  {
    [self resignFirstResponder];
    [self search];
}
/**
 点击原来位置的取消按钮，判断当前输入框是否为空
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED; {
    [self resignFirstResponder];
    if (searchBar.text.length==0) {
        //取消
    }else{
        //搜索
        [self search];
    }
}

/**
 搜索实现代理
 */
-(void)search{
    //实现代理
    if ([self.JHdelegate respondsToSelector:@selector(_searchBarSearch:)]) {
        [self.JHdelegate _searchBarSearch:self];
    }
}
@end
