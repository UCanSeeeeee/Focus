//
//  BNYoutubeSearchAuthorCGI.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
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
