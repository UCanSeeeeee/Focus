//
//  BNBasicDataService.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>
#import "BNAuthorDataInfo.h"
#import "WJBlockTypedefHelper.h"
#import "WJEnumHelper.h"

@class BNSubscribeInfoModel;
@class BNSubscribeWCDB;
@class BNSubscribeMMKV;

NS_ASSUME_NONNULL_BEGIN

@interface BNBasicDataService : NSObject

@property (nonatomic, strong, readonly) BNSubscribeWCDB *dataBase;
@property (nonatomic, strong, readonly) BNSubscribeMMKV *mmkvModel;

+ (instancetype)shareInstance;

#pragma mark - Blibli
- (void)requestBlibliSearchAuthor:(NSString *)author
                         sucBlock:(BNBliBliSearchAuthorSucBlock)sucBlock
                        failBlock:(BNCommonCGIFailBlock)failBlock;

#pragma mark - Youtube
- (void)requestYoutubeSearchContent:(NSString *)searchContent
                           sucBlock:(BNYoutubeSearchAuthorSucBlock)sucBlock
                          failBlock:(BNCommonCGIFailBlock)failBlock;

- (void)requestAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
              platFormType:(BNSubAuthorPlatformType)platFormType
                  sucBlock:(BNYoutubeGetAuthorInfoSucBlock)sucBlock
                 failBlock:(BNCommonCGIFailBlock)failBlock;

// 随机获取Youtube的秘钥
- (NSString *)getRandomYoutubeKeySecret;

@end

NS_ASSUME_NONNULL_END
