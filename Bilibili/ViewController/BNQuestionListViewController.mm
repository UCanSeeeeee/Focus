//
//  BNQuestionListViewController.m
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/4/4.
//

#import "BNQuestionListViewController.h"
#import "BNTitleSubView.h"
#import "MMUIView.h"
#import "BNRouterHelper.h"

#define BNTopDefaultMargin 8
#define BNLeftRightMargin 16
#define BNSubViewMargin 32

@interface BNQuestionListViewController ()

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<BNTitleSubView *> *subViewArray;
@property (nonatomic, strong) UIButton *callAuthorBtn;

@end

@implementation BNQuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.scrollView];
    [self setUpAllSubViews];
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat closeWid = 24;
        btn.frame =CGRectMake(8, BNTopDefaultMargin, closeWid, closeWid);
        [btn setImage:[UIImage svgImageNamed:@"icons_outlined_close" size:CGSizeMake(closeWid, closeWid) tintColor:UIColor.whiteColor] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(leftBarButtonItemReturnAction) forControlEvents:(UIControlEventTouchUpInside)];
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont boldSystemFontOfSize:20] textColor:UIColor.whiteColor textHeight:22 defaultText:@"常见问题" maxWidth:self.view.width textAlignment:NSTextAlignmentCenter];
        _titleLabel.top = BNTopDefaultMargin;
        _titleLabel.centerX = self.view.width / 2;
    }
    return _titleLabel;
}

- (UIButton *)callAuthorBtn {
    if (!_callAuthorBtn) {
        _callAuthorBtn = [[UIButton alloc] initWithFrame:CGRectMake(BNLeftRightMargin, 0, self.view.width - 2 * BNLeftRightMargin, 18)];
        [_callAuthorBtn addTarget:self action:@selector(onClickCallAuthorBtnAction) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"没解决您的问题，点击联系作者"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [_callAuthorBtn setAttributedTitle:title
                          forState:UIControlStateNormal];
        [_callAuthorBtn setTitleColor:UIColor.linkColor forState:UIControlStateNormal];
        [_callAuthorBtn sizeToFit];
    }
    return _callAuthorBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.closeBtn.bottom, self.view.width, self.view.height - self.closeBtn.bottom)];
        _scrollView.contentSize = CGSizeMake(self.view.width, self.view.height);
        _scrollView.backgroundColor = [UIColor blackColor];
    }
    return _scrollView;
}

- (NSMutableArray<BNTitleSubView *> *)subViewArray {
    if (!_subViewArray) {
        _subViewArray = [NSMutableArray array];
    }
    return _subViewArray;
}


- (void)setUpAllSubViews {
    BNTitleSubView *view1 = [[BNTitleSubView alloc] initWithFrame:CGRectMake(BNLeftRightMargin, 0, self.view.width - 2 * BNLeftRightMargin, 16)];
    [view1 updateWithTitle:@"为什么Youtube订阅列表没法刷新？" subTitle:@"1.可以尝试检查你的手机是否连接VPN\n2.若确认连接VPN仍无法访问Youtube订阅列表，可以联系作者"];
    
    BNTitleSubView *view2 = [[BNTitleSubView alloc] initWithFrame:CGRectMake(BNLeftRightMargin, 0, self.view.width - 2 * BNLeftRightMargin, 16)];
    [view2 updateWithTitle:@"为什么搜索不到我想订阅的up主？" subTitle:@"1.可以检查您是否准确输入了up主的昵称\n2.检查您要搜索的up主是否自己修改了昵称\n正常情况下只要输入昵称正确，都会检索出来的"];
    
    BNTitleSubView *view3 = [[BNTitleSubView alloc] initWithFrame:CGRectMake(BNLeftRightMargin, 0, self.view.width - 2 * BNLeftRightMargin, 16)];
    [view3 updateWithTitle:@"订阅数据有存到服务器后台吗？会有泄露问题吗？" subTitle:@"目前本App没有自建后台逻辑，所有数据均直接和平台通信，然后将数据存到本地，无需担心泄露风险。"];
    
    BNTitleSubView *view4 = [[BNTitleSubView alloc] initWithFrame:CGRectMake(BNLeftRightMargin, 0, self.view.width - 2 * BNLeftRightMargin, 16)];
    [view4 updateWithTitle:@"更换手机后订阅的信息还在吗？" subTitle:@"新的手机使用「迁移助手」可以将本地订阅的信息迁移到新的手机上"];
    
    [self.subViewArray addObject:view1];
    [self.subViewArray addObject:view2];
    [self.subViewArray addObject:view3];
    [self.subViewArray addObject:view4];
    
    __block CGFloat marginTop = BNSubViewMargin;
    [self.subViewArray enumerateObjectsUsingBlock:^(BNTitleSubView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.top = marginTop;
        marginTop = obj.bottom + BNSubViewMargin;
        [self.scrollView addSubview:obj];
    }];
    
    self.callAuthorBtn.top = marginTop;
    marginTop = self.callAuthorBtn.bottom + BNSubViewMargin;
    [self.scrollView addSubview:self.callAuthorBtn];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, marginTop);
}

- (void)onClickCallAuthorBtnAction {
    [BNRouterHelper jumpToAuthorWeiboByCurrentNavController:self.navigationController];
}

- (void)leftBarButtonItemReturnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
