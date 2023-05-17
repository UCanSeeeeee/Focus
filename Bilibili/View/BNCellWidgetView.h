//
//  BNCellWidgetView.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNCellWidgetView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                 leftIconName:(NSString *)leftIconName
                         tips:(NSString *)tips
                rightIconName:(NSString *)rightIconName
                   clickBlock:(dispatch_block_t)clickBlock;

+ (CGFloat)getWidgetCellHeight;

@end

NS_ASSUME_NONNULL_END
