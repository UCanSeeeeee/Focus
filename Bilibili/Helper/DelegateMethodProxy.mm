//
//  DelegateMethodProxy.m
//  NSTimerProxyDemo
//
//  Created by chieh on 2022/3/5.
//

#import "DelegateMethodProxy.h"
#import <objc/runtime.h>

static const NSString *BNMethodProxyKey = @"DelegateMethodProxy";

@interface DelegateMethodProxy ()

@property (nonatomic, copy) dispatch_block_t block;

@end

@implementation DelegateMethodProxy

+ (instancetype)initWithBlock:(dispatch_block_t)block {
    DelegateMethodProxy *proxy = [[DelegateMethodProxy alloc] init];
    proxy.block = block;
    return proxy;
}

- (void)addTapGestureToView:(UIView *)view {
    objc_setAssociatedObject(view, (__bridge const void * _Nonnull)(BNMethodProxyKey), self, OBJC_ASSOCIATION_RETAIN);
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)]];
}

- (void)addClickActionToButton:(UIButton *)view {
    objc_setAssociatedObject(view, (__bridge const void * _Nonnull)(BNMethodProxyKey), self, OBJC_ASSOCIATION_RETAIN);
    [view addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClick {
    if (self.block) {
        self.block();
    }
}

@end
