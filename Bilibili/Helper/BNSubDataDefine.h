//
//  BNSubDataDefine.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/6.
//

#ifndef BNSubDataDefine_h
#define BNSubDataDefine_h

@class BNAuthorDataInfo;

#define BNBlibliPlayPrefixUrl @"https://www.bilibili.com/video/"
#define BNYoutubePlayPrefixUrl @"https://www.youtube.com/watch?v="
#define BNWeiBoAuthorProfileSchemeUrl @"sinaweibo://userinfo?uid=5886362593"
#define BNWeiBoAuthorProfileH5Url @"https://weibo.com/5886362593/profile?topnav=1&wvr=6"

#define BNNotificationSubscribeChangeKey @"BNNotificationSubscribeChangeKey"

typedef NS_ENUM(NSUInteger, BNSubRedDotShowType) {
    BNSubRedDotShowTypeNone = 0, ///< 不展示
    BNSubRedDotShowTypeNormal = 1, ///< 普通小圆点
    BNSubRedDotShowTypeNewContent = 2, ///< 有新内容
};

/*
 //    BNSubAuthorPlatformTypeWeChat = 1, ///< 微信公众号
 //    BNSubAuthorPlatformTypeYouTube = 3, ///< YouTube
 //    BNSubAuthorPlatformTypeWeiBo = 4, ///< 微博
 //    BNSubAuthorPlatformTypeZhiHu
 */
#pragma mark - Chieh
typedef NS_ENUM(NSUInteger, BNSubAuthorPlatformType) {
    BNSubAuthorPlatformTypeNone = 0,
    BNSubAuthorPlatformTypeBliBli = 1, ///< B站
    BNSubAuthorPlatformTypeYouTube = 2, ///< 脸书
    BNSubAuthorPlatformTypeCount
};

typedef NS_ENUM(NSUInteger, BNNetWorkErrType) {
    BNNetWorkErrTypeFail = 0, ///< 网络异常
    BNNetWorkErrTypeNone = 1, ///< 搜索不到结果
};

typedef NS_OPTIONS(NSUInteger, BNSubscribeType) {
    BNSubscribeTypeSelf = 1 << 0, ///< 订阅Up主自己
};

typedef void (^BNCommonCGIFailBlock)(int errCode);

typedef void (^BNBliBliSearchAuthorSucBlock)(NSMutableArray<BNAuthorDataInfo *> *authorInfoArray);
typedef void (^BNBliBliGetAuthorInfoSucBlock)(NSMutableArray<BNAuthorDataInfo *> *authorInfo);

typedef void (^BNYoutubeSearchAuthorSucBlock)(NSMutableArray<BNAuthorDataInfo *> *authorInfoArray);
typedef void (^BNYoutubeGetAuthorInfoSucBlock)(NSMutableArray<BNAuthorDataInfo *> *authorInfo);

#endif /* BNSubDataDefine_h */
