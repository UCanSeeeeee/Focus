//
//  BNSearchAuthorTableViewCell.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNSearchAuthorTableViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "BNUIBuildHelper.h"
#import "BNRedDotBuildHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BNMainCardViewModel.h"
#import "BNAuthorDataInfo.h"
#import "BNSubscribeInfoModel.h"
#import "BNSubscribeWCDB.h"

#define BNImageViewWid 44
#define BNImageLeftMargin 16
#define BNImageTextMargin 8

@interface BNSearchAuthorTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *authorDescLabel;
@property (nonatomic, strong) UIButton *subscribeAuthorBtn;
@property (nonatomic, strong) UIView *bottomSeparateLine;

@property (nonatomic, strong) BNAuthorDataInfo *authorDataInfo;

@end

@implementation BNSearchAuthorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorFromHexString:kColorBG1];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickCell)];
        [self.contentView addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)onClickCell {
}

- (void)initSubview {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.authorDescLabel];
    [self.contentView addSubview:self.subscribeAuthorBtn];
    [self.contentView addSubview:self.bottomSeparateLine];
}

- (UIView *)bottomSeparateLine {
    if (!_bottomSeparateLine) {
        _bottomSeparateLine = [BNUIBuildHelper buildSeparateLineLeftMargin:BNImageLeftMargin width:self.contentView.width - BNImageLeftMargin];
    }
    return _bottomSeparateLine;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BNImageViewWid, BNImageViewWid)];
        _avatarImageView.image = [UIImage imageNamed:@"blibliDefaultAvatar.png"];
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

- (UIButton *)subscribeAuthorBtn {
    if (!_subscribeAuthorBtn) {
        CGFloat expandBtnWid = 24;
        _subscribeAuthorBtn = [BNUIBuildHelper buildCommonFollowBtnFrame:CGRectMake(0, 0, expandBtnWid, expandBtnWid) unSelected:@"订阅该Up主" fontSize:14 selectedTips:@"已订阅" cornerRadius:4 target:self action:@selector(didClickSubscribeAuthorBtn:)];
    }
    return _subscribeAuthorBtn;
}

- (void)didClickSubscribeAuthorBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        self.authorDataInfo.subscribeType |= BNSubscribeTypeSelf;
    }else{
        self.authorDataInfo.subscribeType = self.authorDataInfo.subscribeType & ~BNSubscribeTypeSelf;
    }
    BNSubscribeInfoModel *model = [[BNSubscribeInfoModel alloc] initWithUsername:self.authorDataInfo.username subscribeType:self.authorDataInfo.subscribeType];
    [[BNBasicDataService shareInstance].dataBase insertOrReplaceSubscribeInfos:@[model]];
    [btn sizeToFit];
    btn.width += 2 * 8;
    [self layoutAllSubviews];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searhAuthorClickSubscribeAuthorAction:)]) {
        [self.delegate searhAuthorClickSubscribeAuthorAction:self.authorDataInfo.platformType];
    }
}

- (void)updateCellByAuthorInfo:(BNAuthorDataInfo *)authorModel {
    self.authorDataInfo = authorModel;
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
    
    self.subscribeAuthorBtn.selected = authorModel.subscribeType & BNSubscribeTypeSelf;
    
    [self layoutAllSubviews];
}

- (void)layoutAllSubviews {
    self.avatarImageView.left = BNImageLeftMargin;
    self.avatarImageView.centerY = self.height / 2;
    self.authorLabel.left = self.avatarImageView.right + BNImageTextMargin;
    self.authorDescLabel.left = self.authorLabel.left;
    CGFloat padding = 4;
    if (self.authorDescLabel.isHidden) {
        self.authorLabel.centerY = self.avatarImageView.centerY;
    }else{
        self.authorLabel.bottom = self.avatarImageView.centerY - padding;
        self.authorDescLabel.top = self.avatarImageView.centerY + padding;
    }
    
    self.subscribeAuthorBtn.right = self.width - BNImageLeftMargin;
    self.subscribeAuthorBtn.centerY = self.avatarImageView.centerY;
    self.bottomSeparateLine.frame = CGRectMake(BNImageLeftMargin, 0, self.contentView.width - BNImageLeftMargin, 1 / [UIScreen mainScreen].scale);
    self.bottomSeparateLine.bottom = self.height;
}

+ (CGFloat)heightOfAuthorInfo:(BNAuthorDataInfo *)authorModel {
    return 64;
}

@end
