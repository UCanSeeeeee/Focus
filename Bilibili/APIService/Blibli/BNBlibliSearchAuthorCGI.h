//
//  BNBlibliSearchAuthorCGI.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/27.
//

#import <Foundation/Foundation.h>
#import "BNSubDataDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNBlibliSearchAuthorCGI : NSObject

- (instancetype)initWithAuthorName:(NSString *)authorName
                          sucBlock:(BNBliBliSearchAuthorSucBlock)sucBlock
                         failBlock:(BNCommonCGIFailBlock)failBlock;
- (void)start;

@end

NS_ASSUME_NONNULL_END
