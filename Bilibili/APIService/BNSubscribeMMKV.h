//
//  BNSubscribeMMKV.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNSubscribeMMKV : NSObject

#pragma mark - 触发刷新的时间间隔
- (BOOL)updateLastRefreshTimeStamp:(NSUInteger)timeStamp;
- (NSUInteger)getLastRefreshTimeStamp;

@end

NS_ASSUME_NONNULL_END
