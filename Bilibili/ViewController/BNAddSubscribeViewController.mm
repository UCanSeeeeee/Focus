//
//  BNAddSubscribeViewController.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/27.
//

#import "BNAddSubscribeViewController.h"
#import "BNAuthorCellView.h"
#import "BNMainCardViewModel.h"
#import "BNRedDotBuildHelper.h"
#import "BNUIBuildHelper.h"
#import "UIImage+GIF.h"

#define BNCommonLeftRightMargin 32

@interface BNAddSubscribeViewController ()

@property (nonatomic, strong) UILabel *titleLabel; // 导入关注列表
@property (nonatomic, strong) UIView *topSeparateLine;
@property (nonatomic, strong) UIView *middleSeparateLine;
@property (nonatomic, strong) UIView *bottomSeparateLine;

@property (nonatomic, strong) UIView *platformContainerView;
@property (nonatomic, strong) UILabel *platformTipsLabel; // 平台/社区
@property (nonatomic, strong) UILabel *platformNameLabel; // B站/知乎
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UILabel *authorNameLabel; // 用户昵称
@property (strong, nonatomic) UITextField *usernameTextField; // 准确输入用户昵称

@property (nonatomic, strong) UILabel *safeTipsLabel; // 该导入结果只会留存本App本地，不会对您的平台账号产生影响
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation BNAddSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:kColorBG1];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont boldSystemFontOfSize:20] textColor:[UIColor whiteColor] textHeight:20 defaultText:@"导入关注列表" maxWidth:self.view.width textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIView *)topSeparateLine {
    if (!_topSeparateLine) {
        _topSeparateLine = [BNUIBuildHelper buildSeparateLineLeftMargin:BNCommonLeftRightMargin width:self.view.width - 2 * BNCommonLeftRightMargin];
    }
    return _topSeparateLine;
}

- (UIView *)middleSeparateLine {
    if (!_middleSeparateLine) {
        _middleSeparateLine = [BNUIBuildHelper buildSeparateLineLeftMargin:BNCommonLeftRightMargin width:self.view.width - 2 * BNCommonLeftRightMargin];
    }
    return _middleSeparateLine;
}

- (UIView *)bottomSeparateLine {
    if (!_bottomSeparateLine) {
        _bottomSeparateLine = [BNUIBuildHelper buildSeparateLineLeftMargin:BNCommonLeftRightMargin width:self.view.width - 2 * BNCommonLeftRightMargin];
    }
    return _bottomSeparateLine;
}

@end
