//
//  BNAuthorListViewController.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNAuthorListViewController.h"
#import "BNAuthorCellView.h"
#import "BNMainCardViewModel.h"
#import "BNRedDotBuildHelper.h"
#import "BNUIBuildHelper.h"
#import "UIImage+GIF.h"
#import "BNSearchAuthorTableViewCell.h"
#import "BNAuthorListViewModel.h"
#import "BNSearchAuthorViewController.h"

static NSString *const BNSearchAuthorTableViewCellID = @"BNSearchAuthorTableViewCell";
static CGFloat const BNTableViewHeaderHeight = 32.0;
static CGFloat const BNTableViewHeaderPadding = 16.0;
static CGFloat const CloseButtonWidth = 24.0;

@interface BNAuthorListViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,BNSearchAuthorViewControllerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *searchContainer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) BNAuthorListViewModel *viewModel;
@property (nonatomic, strong) BNSearchAuthorViewController *searchViewController;

@end

@implementation BNAuthorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
}

- (void)setupUI {
    [self setupNavigationBar];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchContainer;
    [self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.tableView reloadData];
}

- (void)setupNavigationBar {
    self.title = @"选择要订阅的Up主";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
}

#pragma mark - Event
- (void)didTapCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSearchBarTap:(UIGestureRecognizer *)ges {
    self.searchViewController = [[BNSearchAuthorViewController alloc] init];
    self.searchViewController.modalPresentationStyle = UIModalPresentationCustom;
    self.searchViewController.delegate = self;
    [self embedSubviewFromChildViewController:self.searchViewController];
}

#pragma mark - UI Action
- (void)embedSubviewFromChildViewController:(UIViewController *)childViewController {
    if (childViewController == nil) {
        return;
    }

    [self addChildViewController:childViewController];
    [self.view addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}

- (void)unembedChildViewController:(UIViewController *)childViewController {
    if (childViewController == nil) {
        return;
    }

    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
}

#pragma mark - init
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索Up主";
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_searchBar sizeToFit];
        _searchBar.userInteractionEnabled = NO;
        [_searchBar layoutIfNeeded]; // 提前触发TextField.label出现
        _searchBar.delegate = self;
        _searchBar.barTintColor = [UIColor blackColor];
    }
    return _searchBar;
}

- (UIView *)searchContainer {
    if (!_searchContainer) {
        _searchContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.searchBar.width, self.searchBar.height)];
        _searchContainer.userInteractionEnabled = YES;
        [_searchContainer addSubview:self.searchBar];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSearchBarTap:)];
        [_searchContainer addGestureRecognizer:ges];
    }
    return _searchContainer;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeButton.frame = CGRectMake(0, 0, CloseButtonWidth, CloseButtonWidth);
        [_closeButton setImage:[UIImage svgImageNamed:@"icons_outlined_close" size:CGSizeMake(CloseButtonWidth, CloseButtonWidth) tintColor:UIColor.whiteColor] forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(didTapCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (BNAuthorListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BNAuthorListViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:BNSearchAuthorTableViewCell.class forCellReuseIdentifier:BNSearchAuthorTableViewCellID];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - BNSearchAuthorViewControllerDelegate
- (void)didCancelSelectSearchAuthor {
    [self unembedChildViewController:self.searchViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNSearchAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BNSearchAuthorTableViewCellID
                                                                        forIndexPath:indexPath];
    BNAuthorDataInfo *authorInfo = [self.viewModel getAuthorDataInfoAtSection:indexPath.section index:indexPath.row];
    [cell updateCellByAuthorInfo:authorInfo];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNAuthorDataInfo *authorInfo = [self.viewModel getAuthorDataInfoAtSection:indexPath.section index:indexPath.row];
    return [BNSearchAuthorTableViewCell heightOfAuthorInfo:authorInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return BNTableViewHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self getTableViewHeaderWithTitle:[self.viewModel sectionHeaderTitle:section]];
}

- (UIView *)getTableViewHeaderWithTitle:(NSString *)title {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, BNTableViewHeaderHeight)];
    headerView.backgroundColor = self.tableView.backgroundColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(BNTableViewHeaderPadding, 8, 0, 20)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = self.tableView.backgroundColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = UIColor.whiteColor;
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    if (titleLabel.width > self.view.width - 2 * BNTableViewHeaderPadding) {
        titleLabel.width = self.view.width - 2 * BNTableViewHeaderPadding;
    }
    titleLabel.frame = CGRectMake(4, 8, titleLabel.width, 20);
    titleLabel.alpha = 0.9;
    [headerView addSubview:titleLabel];
    
    return headerView;
}

@end
