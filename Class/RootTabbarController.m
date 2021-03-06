//
//  RootTabbarController.m
//  ZSXC_iOS
//
//  Created by hyjt on 2017/3/31.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "RootTabbarController.h"
#import "UITabBar+Badge.h"
#import "Root_HomeController.h"
#import "Root_InfoController.h"
#import "RootNavController.h"
@interface RootTabbarController ()

@end

@implementation RootTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setUpAllChildViewController];
    
}

/**
 *  添加所有子控制器方法
 */
- (void)_setUpAllChildViewController{
    /*
     设置标签栏选中默认颜色
     */
    self.tabBar.tintColor = kBaseColor;
    
    // 1.添加第一个控制器
    Root_HomeController *home = [[Root_HomeController alloc]init];
    // 2.添加第2个控制器
    Root_InfoController *info = [[Root_InfoController alloc] init];
    
    NSArray *image_on_name = @[@"button_home",@"icon_tab_1"];
    NSArray *image_off_name = @[@"icon_home_1",@"button_icon"];
    NSArray *names = @[@"首页",@"征信管理"];
    
    NSArray *baseVC = @[home,info];

    //设置控制器
    for (int i = 0; i<names.count;i++ ) {
        //展示小红点
//        [self.tabBar showBadgeOnItmIndex:i];
        
        [self _setUpOneChildViewController:baseVC[i] image:[UIImage imageNamed:image_off_name[i]] selectedImage:[UIImage imageNamed:image_on_name[i] ] title:names[i]];
    }
    
}

/**
 *  添加一个子控制器的方法（图片，选中图片，文字）
 */
- (void)_setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    
    //导航--控制器
    RootNavController *navC = [[RootNavController alloc]initWithRootViewController:viewController];

    navC.title = title;
    navC.tabBarItem.image = image;
    //设置选中图片
    navC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.navigationItem.title = title;
    
    [self addChildViewController:navC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
