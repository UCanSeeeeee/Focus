//
//  BNAuthorDataInfo.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/6.
//

#import "BNAuthorDataInfo.h"
#import "NSString+Interact.h"
#import "BNSubscribeInfoModel.h"
#import "BNSubscribeWCDB.h"
#import "ViaBus/ViaBus.h"

@implementation BNAuthorDataInfo
WCDB_IMPLEMENTATION(BNAuthorDataInfo)    //该宏实现绑定到表
WCDB_SYNTHESIZE(BNAuthorDataInfo,username)
WCDB_SYNTHESIZE(BNAuthorDataInfo,imageUrl)
WCDB_SYNTHESIZE(BNAuthorDataInfo,authorName)
WCDB_SYNTHESIZE(BNAuthorDataInfo,fansCount)
WCDB_SYNTHESIZE(BNAuthorDataInfo,videoCount)
WCDB_SYNTHESIZE(BNAuthorDataInfo,followCount)
WCDB_SYNTHESIZE(BNAuthorDataInfo,platformType)
WCDB_SYNTHESIZE(BNAuthorDataInfo,cacheTime)
WCDB_SYNTHESIZE(BNAuthorDataInfo,createdUpdateTime)
WCDB_SYNTHESIZE(BNAuthorDataInfo,contentTips)
WCDB_SYNTHESIZE(BNAuthorDataInfo,redDotShowType)
WCDB_SYNTHESIZE(BNAuthorDataInfo,subscribeType)
WCDB_SYNTHESIZE(BNAuthorDataInfo,contentId)

WCDB_PRIMARY(BNAuthorDataInfo, username)
WCDB_INDEX(BNAuthorDataInfo,"_Index", cacheTime)


+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapperForConfigTag:(NSString *)configTag {
    return @{ @"username" : @"mid", @"imageUrl" : @"upic", @"authorName" : @"uname" , @"fansCount" : @"fans", @"videoCount" : @"videos" };
}

+ (BNAuthorDataInfo *)converFromNetResponseDic:(NSDictionary *)dic {
    BNAuthorDataInfo *dataInfo = [[BNAuthorDataInfo alloc] init];
    dataInfo.username = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"mid"] intValue]];
    dataInfo.imageUrl = [NSString stringWithFormat:@"https:%@",[dic objectForKey:@"upic"]];
    dataInfo.authorName = [dic objectForKey:@"uname"];
    dataInfo.fansCount = [[dic objectForKey:@"fans"] intValue];
    dataInfo.videoCount = [[dic objectForKey:@"videos"] intValue];
    dataInfo.subscribeType = [[BNBasicDataService shareInstance].dataBase getSubscribeInfoByUsername:dataInfo.username].subscribeType;
    
    [VIABUS subscribeEventWithEventname:@"didlogin" andTaget:self handler:^(NSString * eventName, id object) {
        NSLog(@"收到通知");
    }];
    
    return dataInfo;
}

- (NSString *)authorDescContent {
    if (self.fansCount <= 0 && self.videoCount <= 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"粉丝:%@ 内容:%@",[NSString interactCount:self.fansCount],[NSString interactCount:self.videoCount]];
}

- (NSString *)contentUpdateTime {
    if (self.contentTips.length <= 0) {
        return @"";
    }
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:self.createdUpdateTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

- (NSString *)contentAttributeTips {
    if (self.contentTips.length <= 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"最近:%@",self.contentTips];
}

- (NSComparisonResult)comparePublishTime:(BNAuthorDataInfo *)otherModel
{
    NSNumber *number1 = [NSNumber numberWithInt:otherModel.createdUpdateTime];
    NSNumber *number2 = [NSNumber numberWithInt:self.createdUpdateTime];
    NSComparisonResult result = [number1 compare:number2];
    return result;
}

@end
