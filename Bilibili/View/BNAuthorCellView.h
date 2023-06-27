//
//  BNAuthorCellView.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/6.
//

#import "WJDefineHelper.h"

NS_ASSUME_NONNULL_BEGIN

@class BNAuthorDataInfo;

@interface BNAuthorCellView : UITableViewCell

- (void)updateCellAuthorModel:(BNAuthorDataInfo *)authorModel;

+ (CGFloat)heightOfCellView:(BNAuthorDataInfo *)model;

+ (CGFloat)contentHeight;

@end

NS_ASSUME_NONNULL_END
