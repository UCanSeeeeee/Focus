//
//  WJEnumHelper.h
//  Swift - Netflix
//
//  Created by 王杰 on 2023/6/25.
//

#ifndef WJEnumHelper_h
#define WJEnumHelper_h

typedef NS_ENUM(NSUInteger, BNSubRedDotShowType) {
    BNSubRedDotShowTypeNone = 0, ///< 不展示
    BNSubRedDotShowTypeNormal = 1, ///< 普通小圆点
    BNSubRedDotShowTypeNewContent = 2, ///< 有新内容
};

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

#endif /* WJEnumHelper_h */
