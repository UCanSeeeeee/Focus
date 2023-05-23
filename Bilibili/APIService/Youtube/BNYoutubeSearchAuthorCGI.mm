//
//  BNYoutubeSearchAuthorCGI.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNYoutubeSearchAuthorCGI.h"
#import <AFNetworking.h>
#import "BNCommonDataTool.h"
#import "BNSubDataDefine.h"
#import "BNAuthorDataInfo.h"

#define BNYoutubeSearchAuthorAPI @"https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&type=channel"

@interface BNYoutubeSearchAuthorCGI ()

@property (nonatomic, copy) NSString *searchContent;
@property (nonatomic, copy) BNYoutubeSearchAuthorSucBlock sucBlock;
@property (nonatomic, copy) BNCommonCGIFailBlock failBlock;
@property (nonatomic, assign) NSUInteger failCount; // 失败次数，允许重试3次
@end

@implementation BNYoutubeSearchAuthorCGI

- (instancetype)initWithSearchContent:(NSString *)searchContent
                             sucBlock:(BNYoutubeSearchAuthorSucBlock)sucBlock
                            failBlock:(BNCommonCGIFailBlock)failBlock {
    if (self = [super init]) {
        self.searchContent = searchContent;
        self.sucBlock = sucBlock;
        self.failBlock = failBlock;
    }
    return self;
}

- (void)start {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *requestUrl = [NSString stringWithFormat:@"%@&key=%@&q=%@",BNYoutubeSearchAuthorAPI,[[BNBasicDataService shareInstance] getRandomYoutubeKeySecret],self.searchContent];
    //把请求头进行 UTF-8编码
    NSString *path = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"BNYoutubeSearchAuthorCGI 请求成功---%@", responseObject);
        NSMutableArray<BNAuthorDataInfo *> *infoArray = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *result = [responseObject objectForKey:@"items"];
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *objDic = (NSDictionary *)obj;
                    if ([[[objDic objectForKey:@"id"] objectForKey:@"kind"] containsString:@"channel"]) {
                        BNAuthorDataInfo *dataInfo = [[BNAuthorDataInfo alloc] init];
                        NSDictionary *snippetDic = [objDic objectForKey:@"snippet"];
                        dataInfo.username = [snippetDic objectForKey:@"channelId"];
                        dataInfo.imageUrl = [[[snippetDic objectForKey:@"thumbnails"] objectForKey:@"default"] objectForKey:@"url"];
                        dataInfo.authorName = [snippetDic objectForKey:@"channelTitle"];
                        dataInfo.platformType = BNSubAuthorPlatformTypeYouTube;
                        [infoArray addObject:dataInfo];
                    }
                }
            }];
        }
        if (infoArray.count > 0) {
            self.sucBlock(infoArray);
        }else{
            self.failBlock(BNNetWorkErrTypeNone);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"BNYoutubeSearchAuthorCGI 请求失败---%@", error);
        self.failCount ++;
        if (self.failCount < 3) {
            [self start];
        }else{
            if (self.failBlock) {
                self.failBlock(BNNetWorkErrTypeFail);
            }
        }
    }];
}

@end
