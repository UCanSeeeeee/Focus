//
//  BNMainViewController.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/27.
//

#import "BNMainViewController.h"
#import "MMUIView.h"
#import "BNMainListViewModel.h"
#import "BNMainSubCardView.h"
#import "BNAuthorIntroduceView.h"
#import "BNAddSubscribeViewController.h"
#import "BNSearchAuthorViewController.h"
#import <Aspects.h>
#import "MJRefresh.h"
#import "BNSubscribeMMKV.h"

#define kCardViewLeftRightMargin 12
#define kCardViewsListMargin 12
#define kScrollMinContentSizeHeight (self.view.height - kNavBarAndStatusBarHeight)

@interface BNMainViewController ()<UIScrollViewDelegate,BNMainListViewModelDelegate,BNMainSubCardViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BNMainListViewModel *viewModel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) BNAuthorIntroduceView *introduceView;

@end

@implementation BNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"只看你想看";
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

- (void)applicationBecomeActive {
    NSUInteger timeStamp = [[BNBasicDataService shareInstance].mmkvModel getLastRefreshTimeStamp];
    NSUInteger curTimeStamp = [self getCurTimeStamp];
    if (curTimeStamp - timeStamp > 1 * 60 * 60) {
        [self refreshAllSubscribeCard];
    }
}

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
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _scrollView.contentSize = CGSizeMake(self.view.width, kScrollMinContentSizeHeight);
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = FALSE;
        _scrollView.showsHorizontalScrollIndicator = FALSE;
        _scrollView.clipsToBounds = YES;
    }
    return _scrollView;
}

- (void)setUpTopRefreshHeaderToScrollView {
    MJRefreshStateHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshAllSubscribeCard];
        [self.scrollView.mj_header endRefreshing];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.automaticallyChangeAlpha = YES;
    self.scrollView.mj_header = refreshHeader;
}

- (BNMainListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BNMainListViewModel alloc] init];
    }
    return _viewModel;
}

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

- (void)refreshAllSubscribeCard {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BNMainSubCardView class]]) {
            [((BNMainSubCardView *)obj) triggerUpdateSubscribeInfo];
        }
    }];
    
    [[BNBasicDataService shareInstance].mmkvModel updateLastRefreshTimeStamp:[self getCurTimeStamp]];
}

- (NSTimeInterval)getCurTimeStamp {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}

- (void)handleNotification:(NSNotification *)note
{
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
            top = cardView.bottom + 16;
        }
    }];
    
    self.addBtn.centerX = self.view.width / 2;
    self.addBtn.top = self.scrollView.filterBottomView.bottom + 16;
    
    self.introduceView.top = self.addBtn.bottom + 16;
    self.introduceView.centerX = self.view.width / 2;
    
    _scrollView.contentSize = CGSizeMake(self.view.width, MAX(kScrollMinContentSizeHeight, self.introduceView.bottom + 84));
}
@end
