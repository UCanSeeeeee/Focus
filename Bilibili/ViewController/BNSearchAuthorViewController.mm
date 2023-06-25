//
//  BNSearchAuthorViewController.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNSearchAuthorViewController.h"
#import "BNAuthorCellView.h"
#import "BNMainCardViewModel.h"
#import "BNRedDotBuildHelper.h"
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
    }
    return _loadingView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    
    UITapGestureRecognizer *quitGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuitAction)];
    [self.view addGestureRecognizer:quitGes];
    
    [self configTableView];
    [self initNaviBar];
    [self setSearchTextFieldBecomeFirstResponder];
    [self.cancelSearchLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)clickQuitAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelSelectSearchAuthor)]) {
        [self.delegate didCancelSelectSearchAuthor];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 124) style:UITableViewStylePlain];
    self.tableView.y = kNavBarHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:BNSearchAuthorTableViewCell.class forCellReuseIdentifier:BNSearchAuthorTableViewCellID];
    
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:self.tableView];
    [self.tableView setHidden:YES];
    
    UITapGestureRecognizer *quitGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuitAction)];
    [self.tableView addGestureRecognizer:quitGes];
}

- (void)initNaviBar {
    {
        self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kNavBarHeight)];
        self.navigationView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.navigationView];
    }
    
    {
        // 取消button
        self.cancelSearchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
        self.cancelSearchLabel.textColor = [UIColor colorFromHexString:kColorLink_100];
        self.cancelSearchLabel.font = [UIFont systemFontOfSize:17];
        [self.cancelSearchLabel setText:@"取消"];
        [self.cancelSearchLabel sizeToFit];
        self.cancelSearchLabel.height = 24;
        self.cancelSearchLabel.left = self.view.width - 12 - self.cancelSearchLabel.width;
        self.cancelSearchLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *cancelGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuitAction)];
        [self.cancelSearchLabel addGestureRecognizer:cancelGes];
        
        self.cancelSearchLabel.centerY = self.navigationView.height / 2;
        [self.navigationView addSubview:self.cancelSearchLabel];
    }
    
    {
        // searchbar
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.placeholder = @"搜索Up主";
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        searchBar.returnKeyType = UIReturnKeySearch;
        [searchBar sizeToFit];
        searchBar.userInteractionEnabled = YES;
        [searchBar layoutIfNeeded]; // 提前触发TextField.label出现
        searchBar.delegate = self;
        searchBar.height = kNavBarHeight - 2 * 4;
        searchBar.barTintColor = [UIColor blackColor];
        searchBar.tintColor = [UIColor whiteColor];
        searchBar.searchTextField.textColor = [UIColor whiteColor];
        self.searchBar = searchBar;
        self.searchBar.width = self.cancelSearchLabel.left - 8;
        self.searchBar.centerY = self.navigationView.height / 2;
        [self.navigationView addSubview:self.searchBar];
    }
    
    self.loadingView.centerY = self.searchBar.height / 2;
    self.loadingView.right = self.searchBar.width - 42;
    [self.searchBar addSubview:self.loadingView];
    
    [self.view addSubview:self.navigationView];
}

- (void)setSearchTextFieldBecomeFirstResponder {
    [self.searchBar becomeFirstResponder];
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
        UITapGestureRecognizer *quitGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuitAction)];
        [self.view addGestureRecognizer:quitGes];
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

@end
