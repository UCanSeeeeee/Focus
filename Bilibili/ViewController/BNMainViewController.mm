//
//  BNMainViewController.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//


#import <Aspects/Aspects.h>
#import <MJRefresh/MJRefresh.h>

#import "BNMainViewController.h"
#import "WJDefineHelper.h"
#import "BNMainAppPlatformViewModel.h"
#import "BNMainSubCardView.h"
#import "BNAuthorIntroduceView.h"
#import "BNAddSubscribeViewController.h"
#import "BNSearchAuthorViewController.h"
#import "BNSubscribeMMKV.h"

static const CGFloat kCardViewLeftRightMargin = 12;
static const CGFloat kCardViewMargin = 16;

@interface BNMainViewController ()<UIScrollViewDelegate,BNMainSubCardViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BNMainAppPlatformViewModel *viewModel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) BNAuthorIntroduceView *introduceView;

@end

@implementation BNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订阅";
    self.view.backgroundColor = [UIColor blackColor];
    [self setUpTopRefreshHeaderToScrollView];
    [self.view addSubview:self.scrollView];
    [self setUpCardList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:BNNotificationSubscribeChangeKey object:nil];
    [self refreshAllSubscribeCard];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 接入下拉刷新组件 */
- (void)setUpTopRefreshHeaderToScrollView {
    // 下拉刷新执行
    MJRefreshStateHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshAllSubscribeCard];
        // 结束下拉动画
        [self.scrollView.mj_header endRefreshing];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = NO;
    refreshHeader.automaticallyChangeAlpha = YES;
    self.scrollView.mj_header = refreshHeader;
}

/** 接入支持的平台 画UI*/
- (void)setUpCardList {
    [self.viewModel.cardTypeArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BNSubAuthorPlatformType platformType = (BNSubAuthorPlatformType)[obj intValue];
        BNMainSubCardView *cardView = [[BNMainSubCardView alloc] initWithFrame:CGRectMake(kCardViewLeftRightMargin, 0, self.view.width - 2 * kCardViewLeftRightMargin, 32) platformType:platformType];
        cardView.delegate = self;
        [cardView triggerUpdateSubscribeInfo];
        [self.scrollView addSubview:cardView];
    }];
    [self.scrollView addSubview:self.addBtn];
    [self.scrollView addSubview:self.introduceView];
    [self layoutAllSubviews];
}

/** 刷新订阅组件 */
- (void)refreshAllSubscribeCard {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BNMainSubCardView class]]) {
            [(BNMainSubCardView *)obj triggerUpdateSubscribeInfo];
        }
    }];
    // 更新时间戳
    [[BNBasicDataService shareInstance].mmkvModel updateLastRefreshTimeStamp:[self getCurTimeStamp]];
}

- (void)applicationBecomeActive {
    NSUInteger timeStamp = [[BNBasicDataService shareInstance].mmkvModel getLastRefreshTimeStamp];
    NSUInteger curTimeStamp = [self getCurTimeStamp];
    if (curTimeStamp - timeStamp > 1 * 60 * 60) {
        [self refreshAllSubscribeCard];
    }
}

/** 得到当前时间 */
- (NSTimeInterval)getCurTimeStamp {
    // 参数0表示从当前时间开始计算时间间隔。
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}

- (void)handleNotification:(NSNotification *)note {
    NSUInteger changedPlatform = [note.object intValue];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BNMainSubCardView class]]) {
            BNMainSubCardView *cardView = (BNMainSubCardView *)obj;
            if ([cardView getCardPlatformType] == changedPlatform) {
                [cardView triggerUpdateSubscribeInfo];
            }
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self layoutAllSubviews];
    });
}

#pragma mark - BNMainSubCardViewDelegate
- (void)onClickAddSubscribeAction {
    [self didClickAddBtn];
}

- (void)subCardLayoutSubviews {
    [self layoutAllSubviews];
}

#pragma mark - Action
- (void)didClickAddBtn {
    BNSearchAuthorViewController *vc = [[BNSearchAuthorViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)layoutAllSubviews {
    __block CGFloat top = 24;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BNMainSubCardView class]]) {
            BNMainSubCardView *cardView = (BNMainSubCardView *)obj;
            cardView.top = top;
            top = cardView.bottom + kCardViewMargin;
        }
    }];
    
    self.addBtn.centerX = self.view.width / 2;
    self.addBtn.top = self.scrollView.filterBottomView.bottom + kCardViewMargin;
    
    self.introduceView.top = self.addBtn.bottom + kCardViewMargin;
    self.introduceView.centerX = self.view.width / 2;
    
    _scrollView.contentSize = CGSizeMake(self.view.width, MAX(kScrollMinContentSizeHeight, self.introduceView.bottom + 84));
}

#pragma mark - init
- (UIButton *)addBtn {
    if (!_addBtn) {
        CGFloat expandBtnWid = 24;
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, expandBtnWid, expandBtnWid)];
        [_addBtn addTarget:self action:@selector(didClickAddBtn) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setTitle:@"一键订阅" forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_addBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
        [_addBtn sizeToFit];
        _addBtn.width += 2 * 16;
        _addBtn.height += 2 * 8;
        _addBtn.layer.borderColor = UIColor.orangeColor.CGColor;
        _addBtn.layer.borderWidth = 2;
        _addBtn.layer.cornerRadius = 4;
    }
    return _addBtn;
}

- (BNAuthorIntroduceView *)introduceView {
    if (!_introduceView) {
        _introduceView = [[BNAuthorIntroduceView alloc] initWithFrame:CGRectMake(kCardViewLeftRightMargin, 0, self.view.width - 2 * kCardViewLeftRightMargin, 32)];
        _introduceView.fromVC = self;
    }
    return _introduceView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        // 确定scrollView的位置以及能滑动的范围
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _scrollView.contentSize = CGSizeMake(self.view.width, kScrollMinContentSizeHeight);
        _scrollView.delegate = self;
        // 隐藏UIScrollView的垂直和水平滚动条
        _scrollView.showsVerticalScrollIndicator = FALSE;
        _scrollView.showsHorizontalScrollIndicator = FALSE;
        _scrollView.clipsToBounds = YES;
    }
    return _scrollView;
}

- (BNMainAppPlatformViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BNMainAppPlatformViewModel alloc] init];
    }
    return _viewModel;
}

@end
