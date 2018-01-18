//
//  LYWebViewController.m
//  LYWebViewController
//
//  Created by LvYuan on 16/7/9.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "JHWebViewController.h"
@import WebKit;

#define kWebViewEstimatedProgress @"estimatedProgress"
#define kBackImageName @"button_back"
#define kBackImageNameHL @"button_back"
#define kNavHeight 64.f
#define kItemSize 44.f
#define kBackWidth 46.f
#define kProgressDefaultTintColor [UIColor orangeColor]

//扩展
@interface NSArray (Extension)

- (BOOL)exsit:(id)obj;

@end

@implementation NSArray (Extension)

- (BOOL)exsit:(id)object{
    
    for (id obj in self) {
        if (obj == object) {
            return true;
        }
    }
    return false;
}
@end



@interface JHWebViewController()<WKNavigationDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIBarButtonItem * backItem;

@property(nonatomic,strong)UIBarButtonItem * closeItem;

@property(nonatomic,strong)NSMutableArray * leftItems;

@property(nonatomic,strong)WKWebView * webView;

@property(nonatomic,strong)UIProgressView * progressView;
//项目中需求的分享按钮
@property(nonatomic,strong)UIBarButtonItem * shareItem;
//网页urlLabel
@property(nonatomic,strong)UILabel * urlLabel;
//WKContentView
@property(nonatomic,strong)UIView *wkContentView;

@end

@implementation JHWebViewController

//释放监听
- (void)dealloc{
    [_webView removeObserver:self forKeyPath:kWebViewEstimatedProgress];
}
//懒加载
-(UIView *)wkContentView{
    if (!_wkContentView) {
        for (UIView *subView0 in self.webView.scrollView.subviews) {
            if ([subView0 isKindOfClass:NSClassFromString(@"WKContentView")]) {
                _wkContentView = subView0;
            }
        }
    }
    return _wkContentView;
}

- (WKWebView *)webView{
    if (!_webView) {
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, self.navBar.bottom,
                                                              self.view.bounds.size.width, self.view.bounds.size.height-self.navBar.bottom)];
        //打开右滑回退功能
        _webView.allowsBackForwardNavigationGestures = true;
        //有关导航事件的委托代理
        _webView.navigationDelegate = self;
//        _webView.scrollView.delegate = self;
    }
    return _webView;
}
-(UILabel *)urlLabel{
    if (!_urlLabel) {
        _urlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, 20)];
        _urlLabel.numberOfLines = 0;
        _urlLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _urlLabel.textAlignment = NSTextAlignmentCenter;
        _urlLabel.font      = [UIFont systemFontOfSize:12];
        _urlLabel.textColor = [UIColor darkGrayColor];
        _urlLabel.center    = CGPointMake(self.view.size.width/2, 20+self.navBar.bottom);
        
    }
    return _urlLabel;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, self.navBar.bottom - 1.5, self.view.bounds.size.width, 1);
        _progressView.tintColor = self.progressTintColor;
        [self.navigationController.view addSubview:_progressView];
        
    }
    return _progressView;
}

- (UIBarButtonItem *)closeItem{
    if (!_closeItem) {
        
        UIButton * close = [UIButton buttonWithType:UIButtonTypeSystem];
        [close setTitle:@"关闭" forState:UIControlStateNormal];
        close.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        close.frame = CGRectMake(0, 0, kItemSize, kItemSize);
        close.tintColor = self.navigationController.navigationBar.tintColor;
        [close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        //close.backgroundColor = [UIColor lightGrayColor];
        _closeItem = [[UIBarButtonItem alloc]initWithCustomView:close];
        
    }
    return _closeItem;
}

- (UIColor *)progressTintColor{
    if (!_progressTintColor) {
        
        _progressTintColor = kProgressDefaultTintColor;
        
    }
    return _progressTintColor;
}

- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        
        UIButton * back = [UIButton buttonWithType:UIButtonTypeSystem];
        [back setImage:[UIImage imageNamed:kBackImageName] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:kBackImageNameHL] forState:UIControlStateHighlighted];
        [back setTitle:@"返回" forState:UIControlStateNormal];
        back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        back.frame = CGRectMake(0, 0, kBackWidth, kItemSize);
        back.tintColor = self.navigationController.navigationBar.tintColor;
        [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc]initWithCustomView:back];

    }
    return _backItem;
}

-(UIBarButtonItem *)shareItem{
    if (!_shareItem) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info_button"] style:UIBarButtonItemStylePlain target:self action:@selector(_shareAction)];
        _shareItem = item;
    }
    return _shareItem;
}
/**
 *  分享
 */
-(void)_shareAction{
    DLog(@"%@",_webView.URL.absoluteString);
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.navItem.title = _webTitle;
    [self.view addSubview: self.urlLabel];
    [self.view addSubview: self.webView];
    //监听estimatedProgress
    [self.webView addObserver:self forKeyPath:kWebViewEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    //隐藏progressView
    self.progressView.hidden = true;
    
    //左items
    self.leftItems = [NSMutableArray arrayWithObject:self.backItem];
    
    self.closeItem.tintColor = self.navigationController.navigationBar.tintColor;
    //加载请求
    if (![self.urlString isKindOfClass:[NSNull class]]&&self.urlString!=nil&&![self.urlString isEqualToString:@""]) {
        if ([JHCheckUtil isUrlWithString:self.urlString]) {

            NSURL *url = [NSURL URLWithString:_urlString];
            NSURLRequest *reuqest = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:reuqest];
            //为webView添加url展示
        }else{
            return;
        }
        
    }
    /**
     *  如果是含有html源码，将直接加载html源码
     */
    if (![self.tpl isKindOfClass:[NSNull class]]&&self.tpl!=nil) {
        
//        NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
        NSString *headerString = @"";
        [self.webView loadHTMLString:[headerString stringByAppendingString:_tpl] baseURL:nil];
        
    }
    //右侧更多按钮
//    self.navItem.rightBarButtonItem = self.shareItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = !_webView.canGoBack;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_progressView removeFromSuperview];
    _progressView = nil;
    _closeItem = nil;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)setLeftItems:(NSMutableArray *)leftItems{
    _leftItems = leftItems;
    //显示左按钮
    [self setLeftItems];
}

- (void)setLeftItems{
    self.navItem.leftBarButtonItems = _leftItems;
}

- (void)showCloseItem{
    DLog(@"Show");
    if (![_leftItems exsit:_closeItem]) {
        [self.leftItems addObject:_closeItem];
    }
    [self setLeftItems];
}
- (void)hiddenCloseItem{
    DLog(@"Hidden");
    if ([_leftItems exsit:_closeItem]) {
        [self.leftItems removeObject:_closeItem];
    }
    [self setLeftItems];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    _progressView.progress = _webView.estimatedProgress;
}

#pragma mark - actions

- (void)close:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)back:(UIBarButtonItem *)sender{
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self close:nil];
    }
}

#pragma mark - navigation delegate

//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    _progressView.hidden = false;
    self.navigationController.interactivePopGestureRecognizer.enabled = !_webView.canGoBack;
}

//内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
- (void)popGestureRecognizerEnable{
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
//        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        }
        
    }
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
    _progressView.hidden = true;

    self.navItem.title = _webView.title&&![_webView.title isEqualToString:@""]?_webView.title:_webTitle;
    NSArray *arr1;
    NSArray *arr2;
    @try {
        arr1 = [_webView.URL.absoluteString componentsSeparatedByString:@"://"];
        arr2 = [arr1[1] componentsSeparatedByString:@"/"];
        
    } @catch (NSException *exception) {
        arr2 = @[@"浩韵控股集团"];
    } @finally {
        self.urlLabel.text  = [NSString stringWithFormat:@"网页由%@提供",arr2[0]];
    }
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    if (!_webView.canGoBack) {
        [self popGestureRecognizerEnable];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = !_webView.canGoBack;
    
    if (_webView.canGoForward) {
        [self showCloseItem];
    }else{
        [self hiddenCloseItem];
    }
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    _progressView.hidden = true;
    
}



@end


