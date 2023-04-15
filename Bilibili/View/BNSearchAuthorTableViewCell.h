//
//  BNSearchAuthorTableViewCell.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BNAuthorDataInfo;

@protocol BNSearchAuthorTableViewCellDelegate <NSObject>

@optional
typedef NS_ENUM(NSUInteger, BNSubAuthorPlatformType);
- (void)searhAuthorClickSubscribeAuthorAction:(BNSubAuthorPlatformType)platformType;
- (void)searhAuthorClickSubscribeFollowingListAction;

@end

@interface BNSearchAuthorTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BNSearchAuthorTableViewCellDelegate> delegate;

- (void)updateCellByAuthorInfo:(BNAuthorDataInfo *)authorModel;

+ (CGFloat)heightOfAuthorInfo:(BNAuthorDataInfo *)authorModel;

@end

NS_ASSUME_NONNULL_END
