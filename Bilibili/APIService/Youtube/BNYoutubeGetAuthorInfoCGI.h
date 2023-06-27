//
//  BNYoutubeGetAuthorInfoCGI.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>
#import "WJBlockTypedefHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNYoutubeGetAuthorInfoCGI : NSObject

- (instancetype)initWithAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
                           sucBlock:(BNYoutubeGetAuthorInfoSucBlock)sucBlock
                          failBlock:(BNCommonCGIFailBlock)failBlock;
- (void)start;

@end

NS_ASSUME_NONNULL_END
