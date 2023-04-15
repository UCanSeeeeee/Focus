//
//  BNYoutubeSearchAuthorCGI.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/4/3.
//

#import <Foundation/Foundation.h>
#import "BNSubDataDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNYoutubeSearchAuthorCGI : NSObject

- (instancetype)initWithSearchContent:(NSString *)searchContent
                             sucBlock:(BNYoutubeSearchAuthorSucBlock)sucBlock
                            failBlock:(BNCommonCGIFailBlock)failBlock;

- (void)start;

@end

NS_ASSUME_NONNULL_END
