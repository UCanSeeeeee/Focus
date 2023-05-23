//
//  BNMainCardViewModel.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/6.
//

#import "BNMainCardViewModel.h"
#import "BNBasicDataService.h"
#import "BNSubscribeWCDB.h"

@interface BNMainCardViewModel ()

@property (nonatomic, assign) BNSubAuthorPlatformType platFormType;

@end

@implementation BNMainCardViewModel

- (instancetype)initWithplatformType:(BNSubAuthorPlatformType)platformType {
    if (self = [super init]) {
        self.platFormType = platformType;
    }
    return self;
}

- (NSArray<BNAuthorDataInfo *> *)authorModelArray {
    // 暂时只支持订阅up主自己
    return [[BNBasicDataService shareInstance].dataBase getSubscribeInfoBySubscribeType:BNSubscribeTypeSelf platform:self.platFormType];
}

- (void)deleteSubscribeAuthorIndexPath:(NSIndexPath *)indexPath {
    BNAuthorDataInfo *dataInfo = [self.authorModelArray objectAtIndex:indexPath.row];
    [[BNBasicDataService shareInstance].dataBase deleteSubscribeAuthor:dataInfo.username];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCardViewModelSubscribeDataUpdated)]) {
        [self.delegate onCardViewModelSubscribeDataUpdated];
    }
}

/** 成功 */
- (void)fetchRecentSubscribeAuthor {
    [[BNBasicDataService shareInstance] requestAuthorInfos:self.authorModelArray
                                              platFormType:self.platFormType sucBlock:^(NSMutableArray<BNAuthorDataInfo *> *authorInfo) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onCardViewModelAuthorInfoUpdatedSuc)]) {
            [self.delegate onCardViewModelAuthorInfoUpdatedSuc];
        }
    } failBlock:^(int errCode) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onCardViewModelAuthorInfoUpdatedFail)]) {
            [self.delegate onCardViewModelAuthorInfoUpdatedFail];
        }
    }];
}

- (void)disposeSubscribeRedDotIndexPath:(NSIndexPath *)indexPath {
    BNAuthorDataInfo *dataInfo = [self.authorModelArray objectAtIndex:indexPath.row];
    [[BNBasicDataService shareInstance].dataBase disposeSubscribeAuthor:dataInfo.username];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCardViewModelSubscribeDataUpdated)]) {
        [self.delegate onCardViewModelSubscribeDataUpdated];
    }
}

- (void)swipeAllRedDotTips {
    [self.authorModelArray enumerateObjectsUsingBlock:^(BNAuthorDataInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[BNBasicDataService shareInstance].dataBase disposeSubscribeAuthor:obj.username];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCardViewModelSubscribeDataUpdated)]) {
        [self.delegate onCardViewModelSubscribeDataUpdated];
    }
}

@end
