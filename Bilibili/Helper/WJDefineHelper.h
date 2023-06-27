//
//  MMUIView.h
//  CommonDevArchiProject
//
//  Created by chieh on 2022/3/5.
//

#import <UIKit/UIKit.h>
#import "UIImage+EditTool.h"
#import "UIView+Extend.h"
#import "UIView+ViewToolBox.h"
#import "Colours.h"
// Colours 的颜色: https://blog.csdn.net/hitwhylz/article/details/18889469
#import "BNUIBuildHelper.h"
#import "BNBasicDataService.h"
#import "BNCommonDataTool.h"
#import "NSString+Interact.h"

#define kColorBG1 @"#1E1E1E"
#define kColorWXBrand @"#07C160"
#define kColorBlibliBrand @"#FF2F6A"
#define kColorYouTubeBrand @"#FF061C"
#define kColorWeiBoBrand @"#FFD04F"
#define kColorZhihuBrand @"#005CF9"
#define kColorLink_100 @"#7D90A9"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kIs_iphone ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
 /*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))

#define kScrollMinContentSizeHeight (self.view.height - kNavBarAndStatusBarHeight)

#define BNBlibliPlayPrefixUrl @"https://www.bilibili.com/video/"
#define BNYoutubePlayPrefixUrl @"https://www.youtube.com/watch?v="
#define BNWeiBoAuthorProfileSchemeUrl @"s"
#define BNWeiBoAuthorProfileH5Url @"https://weibo.com/5886362593/profile?topnav=1&wvr=6"
#define BNNotificationSubscribeChangeKey @"BNNotificationSubscribeChangeKey"
