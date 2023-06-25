//
//  BNAuthorIntroduceView.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNAuthorIntroduceView.h"
#import "BNAuthorCellView.h"
#import "BNMainCardViewModel.h"
#import "BNRedDotBuildHelper.h"
#import "BNUIBuildHelper.h"
#import "UIImage+GIF.h"
#import "BNCellWidgetView.h"
#import "BNQuestionListViewController.h"
#import "BNRouterHelper.h"
#import "FCAlertView.h"

@interface BNAuthorIntroduceView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray<BNCellWidgetView *> *widgetViewArray;
@property (nonatomic, strong) UILabel *productLabel;

@end


@implementation BNAuthorIntroduceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setUpIntroduceView];
    }
    return self;
}

- (NSMutableArray<BNCellWidgetView *> *)widgetViewArray {
    if (!_widgetViewArray) {
        _widgetViewArray = [NSMutableArray array];
    }
    return _widgetViewArray;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont boldSystemFontOfSize:18] textColor:[UIColor whiteColor] textHeight:18 defaultText:@"关于" maxWidth:self.width textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)productLabel {
    if (!_productLabel) {
        _productLabel = [BNUIBuildHelper buildCommonBottomEndLabel:self.width];
    }
    return _productLabel;
}

- (void)setUpIntroduceView {
    CGFloat topMargin = 0;
    [self addSubview:self.titleLabel];
    topMargin = self.titleLabel.bottom + 12;
    
    BNCellWidgetView *helpView = [[BNCellWidgetView alloc] initWithFrame:CGRectMake(0, 0, self.width, [BNCellWidgetView getWidgetCellHeight])
                                                            leftIconName:@"icons_filled_help"
                                                                    tips:@"帮助和常见问题"
                                                           rightIconName:@"icons_filled_more"
                                                              clickBlock:^{
        BNQuestionListViewController *vc = [[BNQuestionListViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationPopover;
        [self.fromVC presentViewController:vc animated:YES completion:nil];
    }];
    helpView.top = topMargin;
    [self.widgetViewArray addObject:helpView];
    topMargin = helpView.bottom;
    
    BNCellWidgetView *privacyView = [[BNCellWidgetView alloc] initWithFrame:CGRectMake(0, 0, self.width, [BNCellWidgetView getWidgetCellHeight])
                                                               leftIconName:@"icons_filled_book"
                                                                       tips:@"隐私政策"
                                                              rightIconName:@"icons_filled_more"
                                                                 clickBlock:^{
        FCAlertView *alert = [[FCAlertView alloc] init];
        alert.darkTheme = YES;
        [alert showAlertInView:self.fromVC
                     withTitle:@"隐私政策"
                  withSubtitle:@"「订阅」不会收集您的任何信息，出于安全考虑，所以信息均是您和各平台直接进行的访问。\n\n本App完成了各平台互通访问的搭建工作，让您在一个App上快速获取多平台订阅的信息。"
               withCustomImage:nil
           withDoneButtonTitle:@"我知道了"
                    andButtons:nil];
    }];
    privacyView.top = topMargin;
    [self.widgetViewArray addObject:privacyView];
    topMargin = privacyView.bottom;
    
    BNCellWidgetView *authorView = [[BNCellWidgetView alloc] initWithFrame:CGRectMake(0, 0, self.width, [BNCellWidgetView getWidgetCellHeight])
                                                              leftIconName:@"icons_filled_at"
                                                                      tips:@"作者 Chieh"
                                                             rightIconName:@"icons_filled_link"
                                                                clickBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://chiehwang.top"] options:@{} completionHandler:nil];
    }];
    authorView.top = topMargin;
    [self.widgetViewArray addObject:authorView];
    topMargin = authorView.bottom;
    
    [self.widgetViewArray enumerateObjectsUsingBlock:^(BNCellWidgetView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
    
    topMargin += 16;
    self.productLabel.top = topMargin;
    self.productLabel.centerX = self.width / 2;
    [self addSubview:self.productLabel];
    
    self.height = self.productLabel.bottom + 12;
}

@end
