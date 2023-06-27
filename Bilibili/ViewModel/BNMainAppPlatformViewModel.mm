//
//  BNMainListViewModel.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/6.
//

#import "BNMainAppPlatformViewModel.h"
#import "WJEnumHelper.h"

@interface BNMainAppPlatformViewModel ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *cardTypeArray;

@end

@implementation BNMainAppPlatformViewModel

- (NSMutableArray<NSNumber *> *)cardTypeArray {
    if (!_cardTypeArray) {
        _cardTypeArray = [NSMutableArray array];
        [_cardTypeArray addObject:@(BNSubAuthorPlatformTypeBliBli)];
        [_cardTypeArray addObject:@(BNSubAuthorPlatformTypeYouTube)];
    }
    return _cardTypeArray;
}


@end
