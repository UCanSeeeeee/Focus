//
//  BNUIBuildHelper.h
//  BNBitcoinIndexApp
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>
#import "MMUIView.h"
#import "BNSubDataDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNUIBuildHelper : NSObject

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

+ (UIColor *)getThemeColorByPlatformType:(BNSubAuthorPlatformType)platformType;

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

@end

NS_ASSUME_NONNULL_END
