//
//  JHPickTableView.m
//  JHCommonPickerView
//
//  Created by hyjt on 2017/4/11.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHPickTableView.h"
#import "JH_SearchView.h"
static const CGFloat kRowFontSize = 15;
static const CGFloat ksearchBarHeight = 44.0f;
static const CGFloat krowHeight = 44.0f;
static const CGFloat ktableHeight = 200.0f;
//#define ktableHeight  /3
#define kkeyword @"keyWorld"
#define kkeyValue @"valueDesc"
static  NSString *ktableCellIdentify = @"JHPickTableCell";
//将数据更改为text和key
@interface JHPickTableView()<UITableViewDelegate,UITableViewDataSource,JHDIYSearchBarFDelegate>
@property(nonatomic,copy)SelectDataBlock block;

@property(nonatomic,strong)NSArray<NSDictionary *> *dataArray;
@property(nonatomic,strong)NSArray<NSDictionary *> *searchDataArray;
/** 背景图片 */
@property (strong, nonatomic) UIView *backgroundView;
/** 弹出视图 */
@property (strong, nonatomic) UITableView *tableView;
@property (assign ,nonatomic) CGRect keyBoardRec;
@end
@implementation JHPickTableView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray<NSDictionary *> *)titleArray handler:(SelectDataBlock)selectBlock
{
    self.block = selectBlock;
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.dataArray = titleArray;
        //backGround
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.tableView];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}
-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView                  = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        _backgroundView.alpha            = 0;
    }
    return  _backgroundView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), ktableHeight)];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.estimatedRowHeight = krowHeight;
        _tableView.rowHeight       = UITableViewAutomaticDimension;
    }
    return _tableView;
}
//touch remove
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.backgroundView];
    if (!CGRectContainsPoint(self.tableView.frame, point))
    {
        [self dismiss];
    }
}


/**
 show views
 */
- (void)show
{
    // 在主线程中处理,否则在viewDidLoad方法中直接调用,会先加本视图,后加控制器的视图到UIWindow上,导致本视图无法显示出来,这样处理后便会优先加控制器的视图到UIWindow上
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundView.alpha = 1.0f;
            self.tableView.frame = CGRectMake(0, self.frame.size.height-self.tableView.frame.size.height, self.frame.size.width, self.tableView.frame.size.height);
           
        } completion:nil];
    }];
}

/**
 dismiss remove
 */
- (void)dismiss
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 0.0f;
        self.tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.tableView.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - tableDelegate/dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchDataArray? self.searchDataArray.count:self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ktableCellIdentify];
    if (!cell) {
        cell =[[ UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ktableCellIdentify];
    }
    //set title
    cell.textLabel.text          = self.searchDataArray? self.searchDataArray[indexPath.row][kkeyValue]:self.dataArray[indexPath.row][kkeyValue];
    cell.textLabel.font          = [UIFont systemFontOfSize:kRowFontSize];
    cell.textLabel.center        = cell.contentView.center;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //2.调整(iOS8以上)view边距
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        
        _block(self.searchDataArray?[NSString stringWithFormat:@"%@",self.searchDataArray[indexPath.row][kkeyword]]:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][kkeyword]],
               self.searchDataArray?self.searchDataArray[indexPath.row][kkeyValue]:self.dataArray[indexPath.row][kkeyValue]);
    }
    [self dismiss];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ksearchBarHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //        _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLineEtched;
    JH_SearchView *_searchBar  = [[JH_SearchView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetHeight(self.bounds), ksearchBarHeight)withPlaceHold:@"搜索"];
    _searchBar.JHdelegate      = self;
    _searchBar.backgroundColor = [UIColor whiteColor];
    return _searchBar;
}
#pragma mark -  调整view边距
//然后在willDisplayCell方法中加入如下代码：
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark - searchDelegate
/**
 当输入文字改变的代理
 
 @param searchbar JH_SearchView
 */
-(void)_searchTextDidChange:(JH_SearchView *)searchbar
{
    if (searchbar.text.length == 0) {
        self.searchDataArray = nil;
    }else{
        self.searchDataArray = [self _searchData:self.dataArray returnDataByKey:searchbar.text];
    }
    [self.tableView reloadData];
    
}
/**
 当点击搜索的代理
 
 @param searchbar JH_SearchView
 */
-(void)_searchBarSearch:(JH_SearchView *)searchbar{
    
}
/**
 当开始编辑的代理
 
 @param searchbar JH_SearchView
 */
-(void)_searchTextDidBeginEditing:(JH_SearchView *)searchbar;{
    
}
/**
 当结束编辑的代理
 
 @param searchbar JH_SearchView
 */
-(void)_searchTextDidEndEditing:(JH_SearchView *)searchbar;{
    
}
/**
 根据关键字查询数组
 @param data 输入数组
 @param key 关键字查询
 */
-(NSArray *)_searchData:(NSArray *)data returnDataByKey:(NSString *)key{
    NSMutableArray *finalData = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in data) {
        if ([dic[kkeyValue] containsString:key]) {
            [finalData addObject:dic];
        }
    }
    return finalData;
}

/**
 *  键盘出现
 *
 *  @param notif 通知内容，用于监听键盘高度
 */
-(void)keyboardShow:(NSNotification *)notif{
    _keyBoardRec = [[[notif userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    if (_keyBoardRec.origin.y>=self.frame.size.height) {
        _keyBoardRec = CGRectZero;
    }
    //视图的高度为键盘y值减去40
    self.frame = CGRectMake(0, 0-_keyBoardRec.size.height, self.frame.size.width, self.frame.size.height);
    
}
@end
