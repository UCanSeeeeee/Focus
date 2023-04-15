//
//  BNCellWidgetView.m
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/27.
//

#import "BNCellWidgetView.h"
#import "BNAuthorCellView.h"
#import "BNMainCardViewModel.h"
#import "BNRedDotBuildHelper.h"
#import "BNUIBuildHelper.h"
#import "UIImage+GIF.h"
#import "DelegateMethodProxy.h"

#define kBNTipsLeftMargin 24

@interface BNCellWidgetView ()

@property (nonatomic, strong) UIImageView *leftIconView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIImageView *rightIconView;
@property (nonatomic, strong) UIView *bottomSeparateLine;

@end

@implementation BNCellWidgetView

- (instancetype)initWithFrame:(CGRect)frame
                 leftIconName:(NSString *)leftIconName
                         tips:(NSString *)tips
                rightIconName:(NSString *)rightIconName
                   clickBlock:(dispatch_block_t)clickBlock {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftIconView];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.rightIconView];
        [self addSubview:self.bottomSeparateLine];
        self.leftIconView.image = [UIImage svgImageNamed:leftIconName size:CGSizeMake(self.leftIconView.width, self.leftIconView.width) tintColor:[UIColor orangeColor]];
        [self.tipsLabel setText:tips];
        [self.tipsLabel sizeToFit];
        self.rightIconView.image = [UIImage svgImageNamed:rightIconName size:CGSizeMake(self.rightIconView.width, self.rightIconView.width) tintColor:[UIColor whiteColor]];;
        [[DelegateMethodProxy initWithBlock:^{
            if (clickBlock) {
                clickBlock();
            }
        }] addTapGestureToView:self];
        
        [self layoutAllSubViews];
    }
    return self;
}

- (UIView *)bottomSeparateLine {
    if (!_bottomSeparateLine) {
        _bottomSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(kBNTipsLeftMargin, 0, self.width - kBNTipsLeftMargin, 1 / [UIScreen mainScreen].scale)];
        _bottomSeparateLine.backgroundColor = UIColor.whiteColor;
    }
    return _bottomSeparateLine;
}

- (UIImageView *)leftIconView {
    if (!_leftIconView) {
        _leftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    }
    return _leftIconView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor] textHeight:14 defaultText:@"" maxWidth:self.width textAlignment:NSTextAlignmentLeft];
    }
    return _tipsLabel;
}

- (UIImageView *)rightIconView {
    if (!_rightIconView) {
        _rightIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    }
    return _rightIconView;
}

- (void)layoutAllSubViews {
    self.leftIconView.centerY = self.height / 2;
    self.leftIconView.left = 0;
    
    self.tipsLabel.left = kBNTipsLeftMargin;
    self.tipsLabel.centerY = self.leftIconView.centerY;
    self.bottomSeparateLine.bottom = self.height;
    
    self.rightIconView.right = self.width - 4;
    self.rightIconView.centerY = self.leftIconView.centerY;
}

+ (CGFloat)getWidgetCellHeight {
    return 38;
}

@end
