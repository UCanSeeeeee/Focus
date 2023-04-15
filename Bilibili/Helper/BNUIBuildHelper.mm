//
//  BNUIBuildHelper.m
//  BNBitcoinIndexApp
//
//  Created by binbinwang on 2021/12/5.
//

#import "BNUIBuildHelper.h"

@implementation BNUIBuildHelper

+ (UILabel *)buildLabelWithFont:(UIFont *)font
                      textColor:(UIColor *)textColor
                     textHeight:(CGFloat)textHeight
                    defaultText:(NSString *)defaultText
                       maxWidth:(CGFloat)maxWidth
                  textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, textHeight)];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    if (defaultText.length > 0) {
        [label setText:defaultText];
        [label sizeToFit];
        label.width = (label.width > maxWidth) ? maxWidth : label.width;
        label.height = textHeight;
    }
    return label;
}

+ (UIButton *)buildImageButtonWithFrame:(CGRect)frame
                            normalImage:(UIImage *)normalImage
                            selectImage:(UIImage *)selectImage
                           cornerRadius:(CGFloat)cornerRadius
                                 target:(NSObject *)oTarget
                                 action:(SEL)oSelector {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    if (normalImage) {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    
    if (selectImage) {
        [button setImage:selectImage forState:UIControlStateSelected];
    }
    
    if (cornerRadius > 0) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = cornerRadius;
    }
    [button addTarget:oTarget action:oSelector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIColor *)getThemeColorByPlatformType:(BNSubAuthorPlatformType)platformType {
    UIColor *color = nil;
    switch (platformType) {
        case BNSubAuthorPlatformTypeBliBli: {
            color = [UIColor colorFromHexString:kColorBlibliBrand];
        }
            break;
        case BNSubAuthorPlatformTypeYouTube: {
            color = [UIColor colorFromHexString:kColorYouTubeBrand];
        }
            break;
        default:
            break;
    }
    return color;
}

+ (NSString *)getThemeNameByPlatformType:(BNSubAuthorPlatformType)platformType {
    NSString *themeName = @"";
    switch (platformType) {
        case BNSubAuthorPlatformTypeBliBli: {
            themeName = @"Bilibili关注列表🍻";
        }
            break;
        case BNSubAuthorPlatformTypeYouTube: {
            themeName = @"Youtube订阅列表👀";
        }
            break;
        default:
            break;
    }
    return themeName;
}

+ (UIView *)buildSeparateLineLeftMargin:(CGFloat)leftMargin width:(CGFloat)width {
    UIView *separateLine =  [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 0, width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = UIColor.whiteColor;
    separateLine.alpha = 0.2;
    return separateLine;
}

+ (UILabel *)buildCommonBottomEndLabel:(CGFloat)width {
    UILabel *productLabel = [BNUIBuildHelper buildLabelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor] textHeight:14 defaultText:@"——— 喵酱爱订阅，专注多平台订阅 ———" maxWidth:width textAlignment:NSTextAlignmentCenter];
    productLabel.alpha = 0.9;
    return productLabel;
}

+ (UIButton *)buildCommonFollowBtnFrame:(CGRect)frame
                             unSelected:(NSString *)unSelected
                               fontSize:(CGFloat)fontSize
                           selectedTips:(NSString *)selectedTips
                           cornerRadius:(CGFloat)cornerRadius
                                 target:(NSObject *)oTarget
                                 action:(SEL)oSelector {
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn addTarget:oTarget action:oSelector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:unSelected forState:UIControlStateNormal];
    [btn setTitle:selectedTips forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blueberryColor forState:UIControlStateSelected];
    [btn sizeToFit];
    btn.layer.cornerRadius = cornerRadius;
    btn.layer.masksToBounds = YES;
    btn.width += 2 * 8;
    return btn;
}

@end
