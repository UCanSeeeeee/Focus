//
//  BNCommonDataTool.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNCommonDataTool : NSObject

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

// 字符串转时间
+ (NSDate *)nsstringConversionNSDate:(NSString *)dateStr;
// 时间转时间戳
+ (NSString *)dateConversionTimeStamp:(NSDate *)date;
// 字符串转时间戳
+ (NSInteger)dateStringTimeStamp:(NSString *)dateStr;

@end

NS_ASSUME_NONNULL_END
