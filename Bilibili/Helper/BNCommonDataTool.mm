//
//  BNCommonDataTool.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNCommonDataTool.h"

@implementation BNCommonDataTool

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// 字符串转时间
+ (NSDate *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}

// 时间转时间戳
+ (NSString *)dateConversionTimeStamp:(NSDate *)date
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

// 字符串转时间戳
+ (NSInteger)dateStringTimeStamp:(NSString *)dateStr {
    return [[self.class dateConversionTimeStamp:[self.class nsstringConversionNSDate:dateStr]] longLongValue];
}

@end
