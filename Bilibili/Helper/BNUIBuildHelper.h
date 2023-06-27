//
//  BNUIBuildHelper.h
//  BNBitcoinIndexApp
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>
#import "WJDefineHelper.h"
#import "WJEnumHelper.h"

@interface BNUIBuildHelper : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (UILabel *)buildLabelWithFont:(UIFont *)font
                      textColor:(UIColor *)textColor
                     textHeight:(CGFloat)textHeight
                    defaultText:(NSString *)defaultText
                       maxWidth:(CGFloat)maxWidth
                  textAlignment:(NSTextAlignment)textAlignment;

+ (UIButton *)buildImageButtonWithFrame:(CGRect)frame
                            normalImage:(UIImage *)normalImage
                            selectImage:(UIImage *)selectImage
                           cornerRadius:(CGFloat)cornerRadius
                                 target:(NSObject *)oTarget
                                 action:(SEL)oSelector;

+ (NSString *)getThemeNameByPlatformType:(BNSubAuthorPlatformType)platformType;

+ (UIView *)buildSeparateLineLeftMargin:(CGFloat)leftMargin width:(CGFloat)width;

+ (UILabel *)buildCommonBottomEndLabel:(CGFloat)width;

+ (UIButton *)buildCommonFollowBtnFrame:(CGRect)frame
                             unSelected:(NSString *)unSelected
                               fontSize:(CGFloat)fontSize
                           selectedTips:(NSString *)selectedTips
                           cornerRadius:(CGFloat)cornerRadius
                                 target:(NSObject *)oTarget
                                 action:(SEL)oSelector;

NS_ASSUME_NONNULL_END

+ (nullable UIColor *)getThemeColorByPlatformType:(BNSubAuthorPlatformType)platformType;

@end
