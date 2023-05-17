//
//  BNMainListViewModel.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/6.
//

#import "BNMainListViewModel.h"
#import "BNMainCardViewModel.h"
#import "MMUIView.h"
#import "BNAuthorDataInfo.h"

@interface BNMainListViewModel ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *cardTypeArray;

@end

@implementation BNMainListViewModel

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSMutableArray<NSNumber *> *)cardTypeArray {
    if (!_cardTypeArray) {
        _cardTypeArray = [NSMutableArray array];
        [_cardTypeArray addObject:@(BNSubAuthorPlatformTypeBliBli)];
        /**
         提供YouTube接口
         */
//        [_cardTypeArray addObject:@(BNSubAuthorPlatformTypeYouTube)];
    }
    return _cardTypeArray;
}


@end
