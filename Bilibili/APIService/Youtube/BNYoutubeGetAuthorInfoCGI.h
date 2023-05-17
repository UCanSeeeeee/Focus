//
//  BNYoutubeGetAuthorInfoCGI.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/4/3.
//

#import <Foundation/Foundation.h>
#import "BNSubDataDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNYoutubeGetAuthorInfoCGI : NSObject

- (instancetype)initWithAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
                           sucBlock:(BNYoutubeGetAuthorInfoSucBlock)sucBlock
                          failBlock:(BNCommonCGIFailBlock)failBlock;
- (void)start;

@end

NS_ASSUME_NONNULL_END
