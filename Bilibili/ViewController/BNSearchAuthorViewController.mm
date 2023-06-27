//
//  BNSearchAuthorViewController.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNSearchAuthorViewController.h"
#import "BNAuthorCellView.h"
#import "BNMainCardViewModel.h"
#import "BNUIBuildHelper.h"
#import "UIImage+GIF.h"
#import "BNSearchAuthorTableViewCell.h"
#import "BNAuthorListViewModel.h"
#import "BNSearchAuthorViewController.h"
#import "BNSearchAuthorViewModel.h"

static NSString *const BNSearchAuthorTableViewCellID = @"BNSearchAuthorTableViewCell";

@interface BNSearchAuthorViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,BNSearchAuthorViewModelDelegate,BNSearchAuthorTableViewCellDelegate>

@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UILabel *cancelSearchLabel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BNSearchAuthorViewModel *viewModel;

@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, assign) NSUInteger platformSubscribeChanged;

@end

@implementation BNSearchAuthorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.cancelSearchLabel];
    [self.navigationView addSubview:self.searchBar];
    [self.searchBar addSubview:self.loadingView];
    
    [self addTapGestureToView:self.view];
    [self addTapGestureToView:self.tableView];
    [self addTapGestureToView:self.cancelSearchLabel];
    
    [self.searchBar becomeFirstResponder];
    [self.cancelSearchLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)addTapGestureToView:(UIView *)view {
    UITapGestureRecognizer *quitGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuitAction)];
    [view addGestureRecognizer:quitGes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:BNNotificationSubscribeChangeKey object:@(self.platformSubscribeChanged)];
}
#pragma mark - Action
- (void)clickQuitAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelSelectSearchAuthor)]) {
        [self.delegate didCancelSelectSearchAuthor];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
    cell.delegate = self;
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
    titleLabel.frame = CGRectMake(16, 8, titleLabel.width, 20);
    titleLabel.alpha = 0.9;
    [headerView addSubview:titleLabel];
    
    return headerView;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.view removeAllGestureRecognizer];
    if (searchText.length <= 0) {
        [self.tableView setHidden:YES];
//        UITapGestureRecognizer *quitGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuitAction)];
//        [self.view addGestureRecognizer:quitGes];
    } else {
        [self.tableView setHidden:NO];
    }

    NSLog(@"BNSearchAuthorViewController searchText:%@", searchText);
    NSString *trimText = [NSString trimString:searchText];
    if (trimText.length == 0) {
        return;
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    /**
     两种实现方式 尽量避免 performSelector
     [self performSelector:@selector(doSearchAction:) withObject:trimText afterDelay:1];
     */
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self doSearchAction:trimText];
    });
}

- (void)doSearchAction:(NSString *)searchText {
    [self startLoading];
    [self.viewModel requestSearchAuthorByName:searchText];
}

- (void)startLoading {
    self.loadingView.hidden = NO;
}

- (void)stopLoading {
    self.loadingView.hidden = YES;
}

#pragma mark - BNSearchAuthorViewModelDelegate
- (void)searchAuthorDataSuc {
    [self stopLoading];
    [self.tableView reloadData];
}

#pragma mark - BNSearchAuthorTableViewCellDelegate
- (void)searhAuthorClickSubscribeAuthorAction:(BNSubAuthorPlatformType)platformType {
    self.platformSubscribeChanged |= platformType;
}

#pragma mark - init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 124) style:UITableViewStylePlain];
        _tableView.y = kNavBarHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:BNSearchAuthorTableViewCell.class forCellReuseIdentifier:BNSearchAuthorTableViewCellID];
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.hidden = YES;
    }
    return _tableView;
}


- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kNavBarHeight)];
        _navigationView.backgroundColor = [UIColor blackColor];
    }
    return _navigationView;
}

- (UILabel *)cancelSearchLabel {
    if (!_cancelSearchLabel) {
        _cancelSearchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
        _cancelSearchLabel.textColor = [UIColor colorFromHexString:kColorLink_100];
        _cancelSearchLabel.font = [UIFont systemFontOfSize:17];
        _cancelSearchLabel.text = @"取消";
        [_cancelSearchLabel sizeToFit];
        _cancelSearchLabel.height = 24;
        _cancelSearchLabel.left = self.view.width - 12 - self.cancelSearchLabel.width;
        _cancelSearchLabel.userInteractionEnabled = YES;
        _cancelSearchLabel.centerY = self.navigationView.height / 2;
    }
    return _cancelSearchLabel;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索Up主";
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _searchBar.returnKeyType = UIReturnKeySearch;
        [_searchBar sizeToFit];
        _searchBar.userInteractionEnabled = YES;
        [_searchBar layoutIfNeeded]; // 提前触发TextField.label出现
        _searchBar.delegate = self;
        _searchBar.height = kNavBarHeight - 2 * 4;
        _searchBar.barTintColor = [UIColor blackColor];
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.searchTextField.textColor = [UIColor whiteColor];
        _searchBar.width = self.cancelSearchLabel.left - 8;
        _searchBar.centerY = self.navigationView.height / 2;
    }
    return _searchBar;
}

- (BNSearchAuthorViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BNSearchAuthorViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
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
        _loadingView.centerY = self.searchBar.height / 2;
        _loadingView.right = self.searchBar.width - 42;
    }
    return _loadingView;
}
@end
