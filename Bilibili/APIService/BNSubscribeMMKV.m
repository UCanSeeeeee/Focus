//
//  BNSubscribeMMKV.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNSubscribeMMKV.h"
#import <MMKV/MMKV.h>

#define BNLastRefreshTimeStampKey @"BNLastRefreshTimeStampKey"

@interface BNSubscribeMMKV ()

@end

@implementation BNSubscribeMMKV

#pragma mark - 触发刷新的时间间隔
- (BOOL)updateLastRefreshTimeStamp:(NSUInteger)timeStamp {
    return [[MMKV defaultMMKV] setInt64:timeStamp forKey:BNLastRefreshTimeStampKey];
}

- (NSUInteger)getLastRefreshTimeStamp {
    return [[MMKV defaultMMKV] getInt64ForKey:BNLastRefreshTimeStampKey];
}

@end
