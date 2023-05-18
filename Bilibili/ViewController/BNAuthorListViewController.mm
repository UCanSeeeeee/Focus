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

@interface BNAuthorListViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,BNSearchAuthorViewControllerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *searchContainer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BNAuthorListViewModel *viewModel;
@property (nonatomic, strong) BNSearchAuthorViewController *searchViewController;

@end

@implementation BNAuthorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self updateNavigationBarView];
    [self setUpSearchBar];
    [self configureTableView];
}

- (BNAuthorListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BNAuthorListViewModel alloc] init];
    }
    return _viewModel;
}

- (void)updateNavigationBarView {
    self.title = @"选择要订阅的Up主";
    
    CGFloat closeWid = 24;
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame =CGRectMake(0, 0, closeWid, closeWid);
    [btn setImage:[UIImage svgImageNamed:@"icons_outlined_close" size:CGSizeMake(closeWid, closeWid) tintColor:UIColor.whiteColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(leftBarButtonItemReturnAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftItem0 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem0;
}

- (void)setUpSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"搜索Up主";
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [searchBar sizeToFit];
    searchBar.userInteractionEnabled = NO;
    [searchBar layoutIfNeeded]; // 提前触发TextField.label出现
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor blackColor];
    self.searchBar = searchBar;
    
    UIView *searchContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.searchBar.width, self.searchBar.height)];
    searchContainer.userInteractionEnabled = YES;
    [searchContainer addSubview:self.searchBar];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSearchBar:)];
    [searchContainer addGestureRecognizer:ges];
    self.searchContainer = searchContainer;
}

- (void)configureTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView registerClass:BNSearchAuthorTableViewCell.class forCellReuseIdentifier:BNSearchAuthorTableViewCellID];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor blackColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.tableHeaderView = self.searchContainer;
    [self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.tableView reloadData];
}

- (void)leftBarButtonItemReturnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Event
- (void)clickSearchBar:(UIGestureRecognizer *)ges {
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

#pragma mark - UITableView
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNAuthorDataInfo *authorInfo = [self.viewModel getAuthorDataInfoAtSection:indexPath.section index:indexPath.row];
    return [BNSearchAuthorTableViewCell heightOfAuthorInfo:authorInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self getTableViewHeaderWithTitle:[self.viewModel sectionHeaderTitle:section]];
}

- (UIView *)getTableViewHeaderWithTitle:(NSString *)title {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32)];
    headerView.backgroundColor = self.tableView.backgroundColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 0, 20)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = self.tableView.backgroundColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = UIColor.whiteColor;
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    if (titleLabel.width > self.view.width - 2 * 16) {
        titleLabel.width = self.view.width - 2 * 16;
    }
    titleLabel.frame = CGRectMake(4, 8, titleLabel.width, 20);
    titleLabel.alpha = 0.9;
    [headerView addSubview:titleLabel];
    
    return headerView;
}

#pragma mark - BNSearchAuthorViewControllerDelegate
- (void)didCancelSelectSearchAuthor {
    [self unembedChildViewController:self.searchViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
