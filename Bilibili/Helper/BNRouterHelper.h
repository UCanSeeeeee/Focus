//
//  BNRouterHelper.h
//  BNBitcoinIndexApp
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>
#import "MMUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNRouterHelper : NSObject

+ (void)pushToWebUrl:(NSString *)url currentNavController:(UINavigationController *)navVC;

+ (void)jumpToAuthorWeiboByCurrentNavController:(UINavigationController *)navVC;

@end

NS_ASSUME_NONNULL_END
