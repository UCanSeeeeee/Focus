//
//  BNBlibliGetAuthorInfoCGI.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/4/3.
//

#import <Foundation/Foundation.h>
#import "BNSubDataDefine.h"

@class BNAuthorDataInfo;
NS_ASSUME_NONNULL_BEGIN

@interface BNBlibliGetAuthorInfoCGI : NSObject

- (instancetype)initWithAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
                           sucBlock:(BNBliBliGetAuthorInfoSucBlock)sucBlock
                          failBlock:(BNCommonCGIFailBlock)failBlock;
- (void)start;

@end

NS_ASSUME_NONNULL_END
