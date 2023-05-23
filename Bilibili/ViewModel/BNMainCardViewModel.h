//
//  BNMainCardViewModel.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/6.
//

#import <Foundation/Foundation.h>
#import "MMUIView.h"
#import "BNSubDataDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BNMainCardViewModelDelegate <NSObject>

@optional
- (void)onCardViewModelSubscribeDataUpdated;
- (void)onCardViewModelAuthorInfoUpdatedSuc;
- (void)onCardViewModelAuthorInfoUpdatedFail;
@end

@class BNAuthorDataInfo;

@interface BNMainCardViewModel : NSObject

@property (nonatomic, weak) id<BNMainCardViewModelDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray<BNAuthorDataInfo *> *authorModelArray;
@property (nonatomic, assign, readonly) BNSubAuthorPlatformType platFormType;


- (instancetype)initWithplatformType:(BNSubAuthorPlatformType)platformType;

- (void)deleteSubscribeAuthorIndexPath:(NSIndexPath *)indexPath;

- (void)fetchRecentSubscribeAuthor;

- (void)disposeSubscribeRedDotIndexPath:(NSIndexPath *)indexPath;

- (void)swipeAllRedDotTips;

@end

NS_ASSUME_NONNULL_END
