//
//  BNRouterHelper.h
//  BNBitcoinIndexApp
//
//  Created by binbinwang on 2021/12/5.
//

#import <Foundation/Foundation.h>
#import "MMUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNRouterHelper : NSObject

+ (void)pushToWebUrl:(NSString *)url currentNavController:(UINavigationController *)navVC;

+ (void)jumpToAuthorWeiboByCurrentNavController:(UINavigationController *)navVC;

@end

NS_ASSUME_NONNULL_END
