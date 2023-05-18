//
//  BNSubscribeWCDB.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>
#import "MMUIView.h"

NS_ASSUME_NONNULL_BEGIN

@class BNAuthorDataInfo;
@class BNSubscribeInfoModel;

@interface BNSubscribeWCDB : NSObject

- (BOOL)insertOrReplaceAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorInfos;
- (BOOL)insertOrReplaceSubscribeInfos:(NSArray<BNSubscribeInfoModel *> *)subscribeInfos;
- (BNSubscribeInfoModel *)getSubscribeInfoByUsername:(NSString *)username;
- (BNAuthorDataInfo *)getAuthorInfoByUsername:(NSString *)username;
- (NSArray<BNAuthorDataInfo *> *)getSubscribeInfoBySubscribeType:(BNSubscribeType)subscribeType platform:(BNSubAuthorPlatformType)platform;
- (BOOL)deleteSubscribeAuthor:(NSString *)username;
- (BOOL)disposeSubscribeAuthor:(NSString *)username;
@end

NS_ASSUME_NONNULL_END
