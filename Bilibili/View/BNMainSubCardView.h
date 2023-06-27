//
//  BNMainSubCardView.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/6.
//

#import "WJDefineHelper.h"

@class BNMainCardViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol BNMainSubCardViewDelegate <NSObject>

@optional
- (void)onClickAddSubscribeAction;
- (void)subCardLayoutSubviews;

@end

@interface BNMainSubCardView : UIView

@property (nonatomic, weak) id<BNMainSubCardViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame platformType:(BNSubAuthorPlatformType)platformType;

- (void)triggerUpdateSubscribeInfo;

- (BNSubAuthorPlatformType)getCardPlatformType;

@end

NS_ASSUME_NONNULL_END
