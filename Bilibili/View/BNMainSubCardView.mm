//
//  BNMainSubCardView.m
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/6.
//

#import "BNMainSubCardView.h"
#import "BNAuthorCellView.h"
#import "BNMainCardViewModel.h"
#import "BNRedDotBuildHelper.h"
#import "BNUIBuildHelper.h"
#import "UIImage+GIF.h"
#import "BNRouterHelper.h"

#define BNIndicatorLeftRightMargin 12
#define BNSubCardTopMargin 20
#define BNSubCardBottomMargin 12
#define BNRedDotTipsRightMargin 12
#define BNTopContainerHeight 54
#define BNClickAnimationDuration 0.2
#define BNCardBkColor [UIColor colorFromHexString:kColorBG1]
#define BNTableViewHeight [BNAuthorCellView contentHeight] * MIN(3, self.viewModel.authorModelArray.count)

@interface BNMainSubCardView ()<BNMainCardViewModelDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topSeparateLine;
@property (nonatomic, strong) UIView *redDotView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topContainerView;

@property (nonatomic, strong) BNMainCardViewModel *viewModel;

@end

@implementation BNMainSubCardView

- (instancetype)initWithFrame:(CGRect)frame platformType:(BNSubAuthorPlatformType)platformType {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorFromHexString:kColorBG1];
        self.viewModel = [[BNMainCardViewModel alloc] initWithplatformType:platformType];
        self.viewModel.delegate = self;
        [self addSubview:self.topContainerView];
        [self addSubview:self.tableView];
        
        [self reloadCell];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        [_tableView registerClass:BNAuthorCellView.class forCellReuseIdentifier:NSStringFromClass(BNAuthorCellView.class)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = BNCardBkColor;
        
    }
    return _tableView;
}


- (void)reloadCell {
    self.indicatorView.backgroundColor = [BNUIBuildHelper getThemeColorByPlatformType:self.viewModel.platFormType];
    [self.titleLabel setText:[BNUIBuildHelper getThemeNameByPlatformType:self.viewModel.platFormType]];
    [self.titleLabel sizeToFit];
    
    if (self.viewModel.authorModelArray.count > 0) {
    }else{
        self.addBtn.hidden = NO;
        // 点击跳转 SearchAuthorViewController
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAddBtn)];
        [self.topContainerView addGestureRecognizer:tapGes];
    }
    
    [self.tableView reloadData];
    [self layoutAllSubViews];
    
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        [self layoutAllSubViews];
//    });
}

- (UIView *)topContainerView {
    if (!_topContainerView) {
        _topContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, BNTopContainerHeight)];
        [_topContainerView addSubview:self.indicatorView];
        [_topContainerView addSubview:self.titleLabel];
        [_topContainerView addSubview:self.topSeparateLine];
        [_topContainerView addSubview:self.redDotView];
        [_topContainerView addSubview:self.addBtn];
        [_topContainerView addSubview:self.loadingView];
    }
    return _topContainerView;
}

- (UIView *)redDotView {
    if (!_redDotView) {
        _redDotView = [BNRedDotBuildHelper buildNewRedDotView];
        _redDotView.hidden = YES;
    }
    return _redDotView;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        CGFloat iconWid = 14;
        _loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconWid, iconWid)];
        _loadingView.backgroundColor = [UIColor clearColor];
        _loadingView.userInteractionEnabled = NO;//用户不可交互
        NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"RoundLoading" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        _loadingView.image = [UIImage sd_imageWithGIFData:imageData];
        _loadingView.hidden = YES;
    }
    return _loadingView;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        CGFloat expandBtnWid = 24;
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, expandBtnWid, expandBtnWid)];
        [_addBtn addTarget:self action:@selector(didClickAddBtn) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setImage:[UIImage svgImageNamed:@"icons_filled_add2" size:CGSizeMake(expandBtnWid, expandBtnWid) tintColor:UIColor.whiteColor]
                 forState:UIControlStateNormal];
        _addBtn.hidden = YES;
    }
    return _addBtn;
}

- (void)didClickAddBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickAddSubscribeAction)]) {
        [self.delegate onClickAddSubscribeAction];
    }
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 12)];
        _indicatorView.layer.masksToBounds = YES;
        _indicatorView.layer.cornerRadius = 2;
    }
    return _indicatorView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont boldSystemFontOfSize:18] textColor:UIColor.whiteColor textHeight:20 defaultText:@"" maxWidth:self.width - 32 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIView *)topSeparateLine {
    if (!_topSeparateLine) {
        _topSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(BNIndicatorLeftRightMargin, 0, self.width - 2 * BNIndicatorLeftRightMargin, 1 / [UIScreen mainScreen].scale)];
        _topSeparateLine.backgroundColor = UIColor.whiteColor;
        _topSeparateLine.alpha = 0.2;
        _topSeparateLine.hidden = YES;
    }
    return _topSeparateLine;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)layoutAllSubViews {
    self.indicatorView.left = BNIndicatorLeftRightMargin;
    self.indicatorView.centerY = self.topContainerView.height / 2;
    self.titleLabel.centerY = self.indicatorView.centerY;
    self.titleLabel.left = self.indicatorView.right + 8;
    
    self.loadingView.left = self.titleLabel.right + 8;
    self.loadingView.centerY = self.indicatorView.centerY;
    
    self.topSeparateLine.left = BNIndicatorLeftRightMargin;
    self.topSeparateLine.top = self.topContainerView.height - 2;
    self.addBtn.centerY = self.indicatorView.centerY;
    self.addBtn.right = self.width - BNRedDotTipsRightMargin;
    
    self.tableView.top = self.topContainerView.height;
    self.tableView.height = BNTableViewHeight;
    self.height = self.topContainerView.height + self.tableView.height;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(subCardLayoutSubviews)]) {
        [self.delegate subCardLayoutSubviews];
    }
}

#pragma mark - BNMainCardViewModelDelegate
- (void)onCardViewModelSubscribeDataUpdated {
    [self reloadCell];
}

- (void)onCardViewModelAuthorInfoUpdatedSuc {
    self.loadingView.hidden = YES;
    [self reloadCell];
}

- (void)onCardViewModelAuthorInfoUpdatedFail {
    self.loadingView.hidden = YES;
}

- (void)triggerUpdateSubscribeInfo {
    if (self.viewModel.authorModelArray.count <= 0) {
        return;
    }
    [self reloadCell];
    self.loadingView.hidden = NO;
    [self.viewModel fetchAuthorRecentlyAuthor];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNAuthorDataInfo *dataInfo = [self.viewModel.authorModelArray objectAtIndex:indexPath.row];
    if (!dataInfo) {
        UITableViewCell *defaultCell = [[UITableViewCell alloc] init];
        return defaultCell;
    }
    BNAuthorCellView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(BNAuthorCellView.class) forIndexPath:indexPath];
    cell.backgroundColor = BNCardBkColor;
    cell.contentView.backgroundColor = BNCardBkColor;
    [cell updateCellAuthorModel:dataInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BNAuthorDataInfo *dataInfo = [self.viewModel.authorModelArray objectAtIndex:indexPath.row];
    if (!dataInfo) {
        return;
    }
    switch (self.viewModel.platFormType) {
        case BNSubAuthorPlatformTypeBliBli: {
            NSString *urls = [NSString stringWithFormat:@"bilibili://video/%@",dataInfo.contentId];
            NSURL *url = [NSURL URLWithString:urls];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
            }else{
                url = [NSURL URLWithString:@"https://apps.apple.com/cn/app/%E5%93%94%E5%93%A9%E5%93%94%E5%93%A9-%E5%BC%B9%E5%B9%95%E7%95%AA%E5%89%A7%E7%9B%B4%E6%92%AD%E9%AB%98%E6%B8%85%E8%A7%86%E9%A2%91/id736536022"];
                [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
            }
        }
            break;
        case BNSubAuthorPlatformTypeYouTube: {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://watch?v=%@",dataInfo.contentId]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
            }else{
                url = [NSURL URLWithString:@"https://apps.apple.com/cn/app/youtube/id544007664"];
                [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
            }
        } break;
        default:
            break;
    }
    [self.viewModel disposeSubscribeRedDotIndexPath:indexPath];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.authorModelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNAuthorDataInfo *dataInfo = [self.viewModel.authorModelArray objectAtIndex:indexPath.row];
    if (!dataInfo) {
        return 0.01;
    }
    return [BNAuthorCellView heightOfCellView:dataInfo];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 已读
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"已读" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.viewModel disposeSubscribeRedDotIndexPath:indexPath];
    }];
    moreRowAction.backgroundColor = [UIColor clearColor];
    
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消订阅" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.viewModel deleteSubscribeAuthorIndexPath:indexPath];
    }];
    
    return @[deleteRowAction,moreRowAction];
}

- (BNSubAuthorPlatformType)getCardPlatformType {
    return self.viewModel.platFormType;
}

@end
