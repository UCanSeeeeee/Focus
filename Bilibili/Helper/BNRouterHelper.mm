//
//  BNRouterHelper.m
//  BNBitcoinIndexApp
//
//  Created by chieh on 2021/12/5.
//

#import "BNRouterHelper.h"
#import "WKWebViewController.h"

@implementation BNRouterHelper

+ (void)pushToWebUrl:(NSString *)url currentNavController:(UINavigationController *)navVC {
    if (url.length <= 0) {
        NSLog(@"Open web fail is Empty");
        return;
    }
    WKWebViewController *webVC = [[WKWebViewController alloc] initWithUrl:[NSURL URLWithString:url]];
    webVC.view.backgroundColor = [UIColor blackColor];
    [navVC pushViewController:webVC animated:YES];
}

+ (void)jumpToAuthorWeiboByCurrentNavController:(UINavigationController *)navVC {
    NSURL *url = [NSURL URLWithString:BNWeiBoAuthorProfileSchemeUrl];
    // 如果已经安装了这个应用,就跳转
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [BNRouterHelper pushToWebUrl:BNWeiBoAuthorProfileH5Url currentNavController:navVC];
    }
}

@end
