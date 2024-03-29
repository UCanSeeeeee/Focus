//
//  NSString+Interact.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Interact)

+ (NSString *)interactCount:(NSUInteger)interactCount;

+ (NSString *)trimString:(NSString *)nsText;

@end

NS_ASSUME_NONNULL_END
