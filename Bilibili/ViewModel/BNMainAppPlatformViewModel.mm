//
//  BNMainListViewModel.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/6.
//

#import "BNMainAppPlatformViewModel.h"
#import "BNMainCardViewModel.h"
#import "MMUIView.h"
#import "BNAuthorDataInfo.h"

@interface BNMainAppPlatformViewModel ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *cardTypeArray;

@end

@implementation BNMainAppPlatformViewModel

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSMutableArray<NSNumber *> *)cardTypeArray {
    if (!_cardTypeArray) {
        _cardTypeArray = [NSMutableArray array];
        [_cardTypeArray addObject:@(BNSubAuthorPlatformTypeBliBli)];
//        YouTube接口：
        [_cardTypeArray addObject:@(BNSubAuthorPlatformTypeYouTube)];
    }
    return _cardTypeArray;
}


@end
