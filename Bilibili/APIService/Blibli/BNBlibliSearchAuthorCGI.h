//
//  BNBlibliSearchAuthorCGI.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>
#import "WJDefineHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNBlibliSearchAuthorCGI : NSObject

- (instancetype)initWithAuthorName:(NSString *)authorName
                          sucBlock:(BNBliBliSearchAuthorSucBlock)sucBlock
                         failBlock:(BNCommonCGIFailBlock)failBlock;
- (void)start;

@end

NS_ASSUME_NONNULL_END
