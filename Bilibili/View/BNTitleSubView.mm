//
//  BNTitleSubView.m
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/4/4.
//

#import "BNTitleSubView.h"
#import "BNUIBuildHelper.h"

@interface BNTitleSubView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation BNTitleSubView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.width = self.width;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.width = self.width;
        _subTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _subTitleLabel.textColor = UIColor.grayColor;
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (void)updateWithTitle:(NSString *)title
               subTitle:(NSString *)subTitle {
    [self.titleLabel setText:title];
    [self.titleLabel sizeToFit];
    self.titleLabel.width = MIN(self.titleLabel.width, self.width);
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 4;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:subTitle];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, subTitle.length)];
    self.subTitleLabel.attributedText = attrString;
    [self.subTitleLabel sizeToFit];
    self.subTitleLabel.width = MIN(self.subTitleLabel.width, self.width);
    
    self.titleLabel.left = 0;
    self.subTitleLabel.left = 0;
    self.subTitleLabel.top = self.titleLabel.bottom + 8;
    self.height = self.subTitleLabel.bottom;
}

@end
