//
//  BNAuthorDataInfo.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/6.
//

#import <Foundation/Foundation.h>
#import "MMUIView.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNAuthorDataInfo : NSObject <WCTTableCoding>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, assign) NSUInteger fansCount; // 粉丝数
@property (nonatomic, assign) NSUInteger videoCount;
@property (nonatomic, assign) NSUInteger followCount; // 关注的人数
@property (nonatomic, assign) BNSubAuthorPlatformType platformType;
@property (nonatomic, assign) NSUInteger cacheTime;
@property (nonatomic, copy) NSString *contentTips;
@property (nonatomic, assign) NSUInteger createdUpdateTime;
@property (nonatomic, assign) BNSubRedDotShowType redDotShowType;
@property (nonatomic, assign) BNSubscribeType subscribeType;
@property (nonatomic, copy) NSString *contentId;

// API only
@property (nonatomic, copy) NSString *authorDescContent; // 粉丝:xx 内容:xx
@property (nonatomic, copy) NSString *contentUpdateTime; // 2022年3月27日17:00 （发表时间）
@property (nonatomic, copy) NSString *contentAttributeTips; // 最新内容:xxx

WCDB_PROPERTY(username)
WCDB_PROPERTY(imageUrl)
WCDB_PROPERTY(authorName)
WCDB_PROPERTY(fansCount)
WCDB_PROPERTY(videoCount)
WCDB_PROPERTY(followCount)
WCDB_PROPERTY(platformType)
WCDB_PROPERTY(cacheTime)
WCDB_PROPERTY(createdUpdateTime)
WCDB_PROPERTY(contentTips)
WCDB_PROPERTY(redDotShowType)
WCDB_PROPERTY(subscribeType)
WCDB_PROPERTY(contentId)

+ (BNAuthorDataInfo *)converFromNetResponseDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
