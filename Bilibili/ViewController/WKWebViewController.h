//
//  WKWebViewController.h
//  WKWebViewController
//
//  Created by BANYAN on 2017/3/16.
//  Copyright © 2017年 GREEN BANYAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WKWebViewController : UIViewController

@property (nonatomic) NSURL * url;

@property (nonatomic) WKWebView * webView;

@property (nonatomic) UIProgressView * progressView;

-(instancetype)initWithUrl:(NSURL *)url;

-(void)reloadWebView;

@end
