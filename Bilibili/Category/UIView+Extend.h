//
//  UIView+Extend.h
//  BNBitcoinIndexApp
//
//  Created by chieh on 2022/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extend)
@property CGPoint wcOrigin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@property CGFloat x;
@property CGFloat y;
@property CGFloat centerX;
@property CGFloat centerY;

- (UIEdgeInsets)realSafeAreaInsets;

- (void)setX:(CGFloat)x andY:(CGFloat)y;

- (void)moveBy:(CGPoint)delta;
- (void)scaleBy:(CGFloat)scaleFactor;
- (void)fitInSize:(CGSize)aSize;

- (void)fitTheSubviews;
- (void)ceilAllSubviews;
- (void)frameIntegral;

- (void)removeAllSubViews;
- (void)removeSubViewWithTag:(UInt32)uiTag;
- (void)removeSubViewWithClass:(Class _Nonnull)oClass;
- (UIView *_Nullable)viewWithClass:(Class _Nonnull)oClass;

- (UIView *)filterBottomView;
- (void)removeAllGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
