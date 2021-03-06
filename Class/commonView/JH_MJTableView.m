//
//  JH_MJTableView.m
//  JH_MJTableViewTest
//
//  Created by hyjt on 2017/3/14.
//  Copyright © 2017年 jianghong. All rights reserved.
//

#import "JH_MJTableView.h"


@interface JH_MJTableView()
@end
@implementation JH_MJTableView
{
    NSInteger _page;
    //    ODRefreshControl *_refreshControl;
}

/**
 设置刷新控件
 */
-(void)_setRefresh{
    
    [self _setMJRefreshHeader];
    [self _setAutoFooter];
    
}
/**
 模仿QQ下拉刷新
 */
//-(void)addODRefresh{
//    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self];
//    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
//}
-(void)refresh{
    if ([self.JHDelegate respondsToSelector:@selector(JH_MJTableViewFresh)]) {
        [self.JHDelegate JH_MJTableViewFresh];
    }
}
-(void)_setAutoFooter{
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([self.JHDelegate respondsToSelector:@selector(JH_MJTableViewLoadMore)]) {
            [self.JHDelegate JH_MJTableViewLoadMore];
        }
    }];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    [footer setSize:CGSizeMake(self.width, 25)];
    self.mj_footer = footer;
}
//添加刷新部件头部
-(void)_setMJRefreshHeader{
    
    //样式二：设置多张图片（有动画效果）
    NSArray *idleImages = [NSArray arrayWithObjects:
                           
                           [UIImage imageNamed:@"车1"],
                           
                           nil];
    
    NSArray *pullingImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"车1"],nil];
    NSArray *refreshingImages = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"车1"],
                                 [UIImage imageNamed:@"车"],nil];
    __weak typeof(self) weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _page = 0;
        if ([weakSelf.JHDelegate respondsToSelector:@selector(JH_MJTableViewFresh)]) {
            [weakSelf.JHDelegate JH_MJTableViewFresh];
        }
    }];
    
    header.stateLabel.textColor = [UIColor lightGrayColor];
    //-------以上是使用block方法【不包含animationRefresh方法】,动画设置在上面的部分代码---------
    
    //1.设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    //3.设置正在刷新状态的动画图片
    [header setImages:refreshingImages duration:0.3 forState:MJRefreshStateRefreshing];
    //    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //    // Set title
        [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
        [header setTitle:@"释放即可刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    //    //设置字体大小
    //    header.stateLabel.font = [UIFont systemFontOfSize:6];
    self.mj_header = header;
    
    // 隐藏更新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏刷新状态
    //    header.stateLabel.hidden = YES;
    
    
}
/**
 用户选择开启上拉加载
 */
-(void)setFooter{
    NSArray *idleImages = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"车1"],
                           nil];
    
    NSArray *pullingImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"车1"],nil];
    NSArray *refreshingImages = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"车1"],
                                 [UIImage imageNamed:@"车"],nil];
    __weak typeof(self) weakSelf = self;
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _page ++;
        if ([weakSelf.JHDelegate respondsToSelector:@selector(JH_MJTableViewLoadMore)]) {
            [weakSelf.JHDelegate JH_MJTableViewLoadMore];
        }
    }];
    
    // Set the normal state of the animated image
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    //  Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [footer setImages:pullingImages forState:MJRefreshStatePulling];
    // Set the refreshing state of animated images
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [footer.stateLabel setFont:[UIFont systemFontOfSize:10]];
    // Set title
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"放开开始加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载数据" forState:MJRefreshStateRefreshing];
    // Set footer
    self.mj_footer = footer;
}
/**
 根据返回的刷新状态处理
 
 @param refreshState JHRefreshState
 */
-(void)refreshEnd:(JHRefreshState )refreshState{
    switch (refreshState) {
        case JHRefreshStateHeader:
            [self.mj_header endRefreshing];
            [self.mj_footer resetNoMoreData];
            [self.mj_footer setHidden:NO];
            break;
        case JHRefreshStateFooter:
            [self.mj_footer endRefreshing];
            [self.mj_footer setHidden:NO];
            break;
        case JHRefreshStateHeaderNoMore:
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshingWithNoMoreData];
            [self.mj_footer setHidden:YES];
            break;
        case JHRefreshStateFooterNoMore:
            [self.mj_footer endRefreshing];
            [self.mj_footer endRefreshingWithNoMoreData];
            [self.mj_footer setHidden:NO];
            break;
        default:
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            [self.mj_footer setHidden:NO];
            break;
    }
    [self reloadData];
}

//加载数据row page
-(void)loadDataByPage:(NSString *)page rows:(NSString *)rows urlString:(NSString *)urlString data:(NSDictionary *)data newDataHandle:(void(^)(id))newDataBlock{
    
}
/**
 获取刷新样式
 */
+(MJRefreshGifHeader *)getGifHeader:(void(^)())refreshingBlock{
    //样式二：设置多张图片（有动画效果）
    NSArray *idleImages = [NSArray arrayWithObjects:
                           
                           [UIImage imageNamed:@"车1"],
                           
                           nil];
    
    NSArray *pullingImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"车1"],nil];
    NSArray *refreshingImages = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"车1"],
                                 [UIImage imageNamed:@"车"],nil];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        refreshingBlock();
    }];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    //-------以上是使用block方法【不包含animationRefresh方法】,动画设置在上面的部分代码---------
    
    //1.设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    //3.设置正在刷新状态的动画图片
    [header setImages:refreshingImages duration:0.3 forState:MJRefreshStateRefreshing];
    //    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //    // Set title
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"释放即可刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    //    //设置字体大小
    //    header.stateLabel.font = [UIFont systemFontOfSize:6];
    
    // 隐藏更新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏刷新状态
    //    header.stateLabel.hidden = YES;
    return header;
}


@end
