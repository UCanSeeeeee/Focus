//
//  BNYoutubeGetAuthorInfoCGI.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNYoutubeGetAuthorInfoCGI.h"
#import <AFNetworking.h>
#import "BNCommonDataTool.h"
#import "BNAuthorDataInfo.h"
#import "BNCommonDataTool.h"

#define BNYoutubeGetAuthorInfoAPI @"https://youtube.googleapis.com/youtube/v3/search?part=snippet&order=date&type=video"

@interface BNYoutubeGetAuthorInfoCGI ()
@property (nonatomic, copy) NSArray<BNAuthorDataInfo *> *authorDataArray;
@property (nonatomic, copy) BNYoutubeGetAuthorInfoSucBlock sucBlock;
@property (nonatomic, copy) BNCommonCGIFailBlock failBlock;
@end

@implementation BNYoutubeGetAuthorInfoCGI

- (instancetype)initWithAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
                           sucBlock:(BNYoutubeGetAuthorInfoSucBlock)sucBlock
                          failBlock:(BNCommonCGIFailBlock)failBlock {
    if (self = [super init]) {
        self.authorDataArray = authorDataArray;
        self.sucBlock = sucBlock;
        self.failBlock = failBlock;
    }
    return self;
}

- (void)start {
    __block NSMutableArray<BNAuthorDataInfo *> *infoArray = [NSMutableArray array];
    __block NSUInteger responseCount = 0;
    [self.authorDataArray enumerateObjectsUsingBlock:^(BNAuthorDataInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *requestUrl = [NSString stringWithFormat:@"%@&key=%@&channelId=%@",BNYoutubeGetAuthorInfoAPI,[[BNBasicDataService shareInstance] getRandomYoutubeKeySecret],obj.username];
        //把请求头进行 UTF-8编码
        NSString *path = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"BNYoutubeGetAuthorInfoCGI 请求成功---%@", responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *result = [responseObject objectForKey:@"items"];
                if (result.count > 0) {
                    NSDictionary *recentlyContentDic = [result firstObject];
                    NSDictionary *snippetDic = [recentlyContentDic objectForKey:@"snippet"];
                    NSString *publishString = [snippetDic objectForKey:@"publishTime"];
                    if ([publishString containsString:@"T"]) {
                        publishString = [publishString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        publishString = [publishString stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
                    }
                    NSUInteger publishTime = (NSUInteger)[BNCommonDataTool dateStringTimeStamp:publishString];
//                    if (publishTime > obj.createdUpdateTime) {
                        NSString *contentTips = [snippetDic objectForKey:@"title"];
                        obj.contentTips = contentTips; // 요절복통 5인팟
                        obj.createdUpdateTime = publishTime; //2022-10-09 14:53:08"
                        obj.redDotShowType = BNSubRedDotShowTypeNewContent;
                        obj.contentId = [[recentlyContentDic objectForKey:@"id"] objectForKey:@"videoId"]; // yhnR4w_utHs
//                    }
                }
            }
            responseCount ++;
            [infoArray addObject:obj];
            if (responseCount == self.authorDataArray.count) {
                if (self.sucBlock) {
                    self.sucBlock(infoArray);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"BNYoutubeGetAuthorInfoCGI 请求失败---%@", error);
            if (self.failBlock) {
                self.failBlock(BNNetWorkErrTypeFail);
            }
        }];
    }];
}

@end
