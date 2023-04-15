//
//  BNAuthorCellView.m
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/6.
//

#import "BNAuthorCellView.h"
#import <SDWebImage/SDWebImage.h>
#import "BNUIBuildHelper.h"
#import "BNRedDotBuildHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BNMainCardViewModel.h"
#import "BNAuthorDataInfo.h"

#define BNImageViewWid 44
#define BNImageTextMargin 8
#define BNImageLeftMargin 16
#define BNAuthorRedDotMargin 4
#define BNIndicatorLeftRightMargin 12
#define BNRedDotTipsRightMargin 12
#define BNCommonTopBottomMargin 12
#define BNAvatarContentMargin 8
#define BNCellViewDefaultHeight (BNImageViewWid + 2 * BNCommonTopBottomMargin)
#define BNContentLabelHeight 14
#define BNCellViewContentHeight (BNCellViewDefaultHeight + BNContentLabelHeight + BNAvatarContentMargin)

@class BNAuthorDataInfo;

@interface BNAuthorCellView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *authorDescLabel;
@property (nonatomic, strong) UILabel *newContentLabel; // 最近更新的内容
@property (nonatomic, strong) UILabel *newUpdateTimeLabel; ///更新的时间
@property (nonatomic, strong) UILabel *redDotTipsLabel; // 红点内容
@property (nonatomic, strong) UIView *bottomSeparateLine;

@end

@implementation BNAuthorCellView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpAllViews];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.avatarImageView.hidden = YES;
    self.authorLabel.hidden = YES;
    self.authorDescLabel.hidden = YES;
    self.newContentLabel.hidden = YES;
    self.newUpdateTimeLabel.hidden = YES;
    self.redDotTipsLabel.hidden = YES;
    self.bottomSeparateLine.hidden = YES;
}

- (void)setUpAllViews {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.authorDescLabel];
    [self.contentView addSubview:self.newContentLabel];
    [self.contentView addSubview:self.newUpdateTimeLabel];
    [self.contentView addSubview:self.redDotTipsLabel];
    [self.contentView addSubview:self.bottomSeparateLine];
}

- (UILabel *)redDotTipsLabel {
    if (!_redDotTipsLabel) {
        _redDotTipsLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont boldSystemFontOfSize:14] textColor:UIColor.pinkColor textHeight:16 defaultText:@"" maxWidth:self.width/2 textAlignment:NSTextAlignmentLeft];
        _redDotTipsLabel.userInteractionEnabled = YES;
        _redDotTipsLabel.hidden = YES;
    }
    return _redDotTipsLabel;
}

- (UILabel *)newContentLabel {
    if (!_newContentLabel) {
        _newContentLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont systemFontOfSize:BNContentLabelHeight - 2] textColor:UIColor.whiteColor textHeight:BNContentLabelHeight defaultText:@"" maxWidth:self.width/2 textAlignment:NSTextAlignmentLeft];
        _newContentLabel.alpha = 0.9;
        _newContentLabel.hidden = YES;
    }
    return _newContentLabel;
}

- (UILabel *)newUpdateTimeLabel {
    if (!_newUpdateTimeLabel) {
        _newUpdateTimeLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont systemFontOfSize:BNContentLabelHeight - 2] textColor:UIColor.whiteColor textHeight:BNContentLabelHeight defaultText:@"" maxWidth:self.width/2 textAlignment:NSTextAlignmentRight];
        _newUpdateTimeLabel.alpha = 0.9;
        _newUpdateTimeLabel.hidden = YES;
    }
    return _newUpdateTimeLabel;
}

- (UIView *)bottomSeparateLine {
    if (!_bottomSeparateLine) {
        _bottomSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(BNIndicatorLeftRightMargin, 0, self.contentView.width - 2 * BNIndicatorLeftRightMargin, 1 / [UIScreen mainScreen].scale)];
        _bottomSeparateLine.backgroundColor = UIColor.whiteColor;
        _bottomSeparateLine.alpha = 0.2;
    }
    return _bottomSeparateLine;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BNImageViewWid, BNImageViewWid)];
        _avatarImageView.hidden = YES;
        _avatarImageView.layer.cornerRadius =4;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont systemFontOfSize:16] textColor:UIColor.whiteColor textHeight:18 defaultText:@"" maxWidth:self.width/2 textAlignment:NSTextAlignmentLeft];
        _authorLabel.hidden = YES;
    }
    return _authorLabel;
}

- (UILabel *)authorDescLabel {
    if (!_authorDescLabel) {
        _authorDescLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont systemFontOfSize:12] textColor:UIColor.whiteColor textHeight:14 defaultText:@"" maxWidth:self.width/2 textAlignment:NSTextAlignmentLeft];
        _authorDescLabel.alpha = 0.8;
        _authorDescLabel.hidden = YES;
    }
    return _authorDescLabel;
}

- (void)updateCellAuthorModel:(BNAuthorDataInfo *)authorModel {
    if (authorModel.imageUrl.length <= 0 && authorModel.authorName.length <= 0) {
        // 数据不能都为空
        assert(false);
        return;
    }
    
    self.redDotTipsLabel.textColor = [BNUIBuildHelper getThemeColorByPlatformType:authorModel.platformType];
    
    if (authorModel.imageUrl.length > 0) {
        self.avatarImageView.hidden = NO;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:authorModel.imageUrl] placeholderImage:[UIImage imageNamed:@"image"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            NSLog(@"%ld",receivedSize/expectedSize);
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            switch (cacheType) {
                case SDImageCacheTypeNone:
                    break;
                case SDImageCacheTypeDisk:
                    break;
                case SDImageCacheTypeMemory:
                    break;
                default:
                    break;
            }
            if (image) {
                [self.avatarImageView setImage:image];
            }
        }];
    }
    
    if (authorModel.authorName.length > 0) {
        self.authorLabel.hidden = NO;
        [self.authorLabel setText:authorModel.authorName];
        [self.authorLabel sizeToFit];
        self.authorLabel.width = MIN(self.authorLabel.width, self.width / 2);
    }
    
    if (authorModel.authorDescContent.length > 0) {
        self.authorDescLabel.hidden = NO;
        [self.authorDescLabel setText:authorModel.authorDescContent];
        [self.authorDescLabel sizeToFit];
        self.authorDescLabel.width = MIN(self.authorDescLabel.width, self.width / 2);
    }
    
    if (authorModel.contentAttributeTips.length > 0) {
        self.newContentLabel.hidden = NO;
        [self.newContentLabel setText:authorModel.contentAttributeTips];
        [self.newContentLabel sizeToFit];
        self.newContentLabel.width = MIN(self.newContentLabel.width, self.width - 2 * BNImageLeftMargin);
    }
    
    if (authorModel.contentUpdateTime.length > 0) {
        self.newUpdateTimeLabel.hidden = NO;
        [self.newUpdateTimeLabel setText:authorModel.contentUpdateTime];
        [self.newUpdateTimeLabel sizeToFit];
        self.newUpdateTimeLabel.width = MIN(self.newUpdateTimeLabel.width, self.width / 2);
    }
    
    switch (authorModel.redDotShowType) {
        case BNSubRedDotShowTypeNewContent:
            self.redDotTipsLabel.hidden = NO;
            [self.redDotTipsLabel setText:@"有新内容◉"];
            [self.redDotTipsLabel sizeToFit];
            break;
            
        default:
            break;
    }
    
    self.bottomSeparateLine.hidden = NO;
    
    [self layoutAllSubViews];
}

- (void)layoutAllSubViews {
    if (self.newContentLabel.isHidden && self.newUpdateTimeLabel.isHidden) {
        self.avatarImageView.centerY = self.height / 2;
    }else{
        self.avatarImageView.top = BNCommonTopBottomMargin;
    }
    self.avatarImageView.left = BNImageLeftMargin;
    self.authorLabel.left = self.avatarImageView.right + BNImageTextMargin;
    self.authorDescLabel.left = self.authorLabel.left;
    if (self.authorDescLabel.isHidden) {
        self.authorLabel.centerY = self.avatarImageView.centerY;
    }else{
        self.authorLabel.bottom = self.avatarImageView.centerY - 2;
        self.authorDescLabel.top = self.avatarImageView.centerY + 2;
    }
    
    if (self.redDotTipsLabel.isHidden && !self.newUpdateTimeLabel.isHidden) {
        self.newUpdateTimeLabel.centerY = self.avatarImageView.centerY;
        self.newUpdateTimeLabel.right = self.width - BNRedDotTipsRightMargin;
    } else if (!self.redDotTipsLabel.isHidden && self.newUpdateTimeLabel.isHidden) {
        self.redDotTipsLabel.right = self.width - BNRedDotTipsRightMargin;
        self.redDotTipsLabel.centerY = self.authorLabel.centerY;
    } else if (!self.redDotTipsLabel.isHidden && !self.newUpdateTimeLabel.isHidden) {
        self.redDotTipsLabel.right = self.width - BNRedDotTipsRightMargin;
        self.redDotTipsLabel.bottom = self.avatarImageView.centerY - 2;
        self.newUpdateTimeLabel.top = self.avatarImageView.centerY + 2;
        self.newUpdateTimeLabel.right = self.width - BNRedDotTipsRightMargin;
    }
    
    self.newContentLabel.left = self.avatarImageView.left;
    self.newContentLabel.top = self.avatarImageView.bottom + BNAvatarContentMargin;
    
    self.bottomSeparateLine.frame = CGRectMake(BNIndicatorLeftRightMargin, 0, self.contentView.width - 2 * BNIndicatorLeftRightMargin, 1 / [UIScreen mainScreen].scale);
    self.bottomSeparateLine.bottom = self.height;
    [self bringSubviewToFront:self.bottomSeparateLine];
}

+ (CGFloat)heightOfCellView:(BNAuthorDataInfo *)model {
    if (model.contentAttributeTips.length > 0 || model.contentUpdateTime.length > 0) {
        return BNCellViewContentHeight;
    }
    return BNCellViewDefaultHeight;
}

+ (CGFloat)contentHeight {
    return BNCellViewContentHeight + 6;
}

@end
