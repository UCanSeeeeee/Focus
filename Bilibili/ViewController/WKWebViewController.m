//
//  WKWebViewController.m
//  WKWebViewController
//
//  Created by BANYAN on 2017/3/16.
//  Copyright © 2017年 GREEN BANYAN. All rights reserved.
//

#import "WKWebViewController.h"
#import "UIBarButtonItem+Extension.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kIs_iphone ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic) UIBarButtonItem * backItem; //refrsh letBarButtonItem for just pop

@property (nonatomic) UIBarButtonItem * goBackItem; //goback ation for the leftBarButtonItems when the webView can goback

@property (nonatomic) UIBarButtonItem * dismissItem; //dismiss action(popViewController) for the leftBarButtonItems when the push page > 1

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)reloadWebView{
    [self.webView reload];
}

-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    
    if (self) {
        self.url = url;
    }
    return self;
}

#pragma mark -- setters and getters
-(void)setUrl:(NSURL *)url{
    _url = url;
}
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, self.view.frame.size.width, 2)];
        [_progressView setTintColor:[UIColor blueColor]];
    }
    return _progressView;
}

-(WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, self.view.frame.size.width, self.view.frame.size.height - kNavBarAndStatusBarHeight)];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [_webView sizeToFit];
        _webView.backgroundColor = [UIColor blackColor];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}
-(UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back_icon" highlightImage:@"header_back_icon_highlight"];
    }
    return _backItem;
}

-(UIBarButtonItem *)goBackItem{
    if (!_goBackItem) {
        _goBackItem = [UIBarButtonItem itemWithTarget:self action:@selector(goback) image:@"header_back_icon" highlightImage:@"header_back_icon_highlight"];
    }
    return _goBackItem;
}
-(UIBarButtonItem *)dismissItem{
    if (!_dismissItem) {
        _dismissItem = [UIBarButtonItem itemWithTarget:self action:@selector(dismiss) title:@"关闭" titleColor:[UIColor whiteColor]];
    }
    return _dismissItem;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goback{
    [self.webView goBack];
}
-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%s,change = %@",__func__,change);
    
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == _webView) {
        [_progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        ///***
        if (_webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [_progressView setProgress:0.0f animated:NO];
            }];
        }
        //;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:nil];
    }
    
}

#pragma mark -- WKWebViewDelegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (webView.title.length > 10) {
        self.navigationItem.title = [webView.title substringToIndex:9];
    }else{
        self.navigationItem.title = webView.title;
    }
    
    [self updateUIBarButtonItem];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if (navigationAction.navigationType == WKNavigationTypeBackForward) {
        if (webView.backForwardList.backList.count == 0) {
            [self updateUIBarButtonItem];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark -- refresh UIBarButtonItem
-(void)updateUIBarButtonItem{
    if (self.webView.canGoBack) {
        ///***
        UIBarButtonItem * marin = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        marin.width = -6.5;
        [self.navigationItem setLeftBarButtonItems:@[self.goBackItem,self.dismissItem]animated:NO];
        //;
    }else{
        ///**
        [self.navigationItem setLeftBarButtonItems:@[self.backItem]];
        //;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
