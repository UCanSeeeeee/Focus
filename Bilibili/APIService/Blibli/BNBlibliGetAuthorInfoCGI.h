//
//  BNBlibliGetAuthorInfoCGI.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>
#import "WJDefineHelper.h"

@class BNAuthorDataInfo;
NS_ASSUME_NONNULL_BEGIN

@interface BNBlibliGetAuthorInfoCGI : NSObject

- (instancetype)initWithAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
                           sucBlock:(BNBliBliGetAuthorInfoSucBlock)sucBlock
                          failBlock:(BNCommonCGIFailBlock)failBlock;
- (void)start;

@end

NS_ASSUME_NONNULL_END
