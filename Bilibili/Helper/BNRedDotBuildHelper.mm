//
//  BNRedDotBuildHelper.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/6.
//

#import "BNRedDotBuildHelper.h"
#import "BNUIBuildHelper.h"

#define BNRedDotNewHeight 20

@implementation BNRedDotBuildHelper

+ (UIView *)buildNewRedDotView {
    UILabel *label = [BNUIBuildHelper buildLabelWithFont:[UIFont systemFontOfSize:12] textColor:UIColor.whiteColor textHeight:14 defaultText:@"New" maxWidth:32 textAlignment:NSTextAlignmentCenter];
    label.width += 2 * 6;
    label.height += 2 * 4;
    label.backgroundColor = UIColor.strawberryColor;
    label.layer.cornerRadius = label.height / 2;
    label.layer.masksToBounds = YES;
    label.tag = BNSubRedDotShowTypeNormal;
    return label;
}

+ (UIView *)buildNormalRedDotView {
    UIView *reddot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    reddot.layer.cornerRadius = reddot.height / 2;
    reddot.layer.masksToBounds = YES;
    reddot.backgroundColor = UIColor.strawberryColor;;
    reddot.tag = BNSubRedDotShowTypeNormal;
    return reddot;
}

@end
