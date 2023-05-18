//
//  BNBlibliGetAuthorInfoCGI.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNBlibliGetAuthorInfoCGI.h"
#import <AFNetworking.h>
#import "BNCommonDataTool.h"
#import "BNSubDataDefine.h"
#import "BNAuthorDataInfo.h"

#define BNBlibliGetAuthorInfoAPI @"https://api.bilibili.com/x/space/arc/search?"

@interface BNBlibliGetAuthorInfoCGI ()

@property (nonatomic, copy) NSArray<BNAuthorDataInfo *> *authorDataArray;
@property (nonatomic, copy) BNBliBliGetAuthorInfoSucBlock sucBlock;
@property (nonatomic, copy) BNCommonCGIFailBlock failBlock;

@end

@implementation BNBlibliGetAuthorInfoCGI

- (instancetype)initWithAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
                          sucBlock:(BNBliBliGetAuthorInfoSucBlock)sucBlock
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
        NSString *requestUrl = [NSString stringWithFormat:@"%@mid=%@",BNBlibliGetAuthorInfoAPI,obj.username];
        //把请求头进行 UTF-8编码
        NSString *path = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"BNBlibliGetAuthorInfoCGI 请求成功---%@", responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *result = [[[responseObject objectForKey:@"data"] objectForKey:@"list"] objectForKey:@"vlist"];
                if (!result || result.count <= 0) {
                }else{
                    NSDictionary *recentlyContentDic = [result firstObject];
                    NSUInteger createdTimeStamp = [[recentlyContentDic objectForKey:@"created"] intValue];
                    if (createdTimeStamp > obj.createdUpdateTime) {
                        NSString *contentTips = [recentlyContentDic objectForKey:@"title"];
                        obj.contentId = [recentlyContentDic objectForKey:@"bvid"];
                        obj.contentTips = contentTips;
                        obj.createdUpdateTime = createdTimeStamp;
                        obj.redDotShowType = BNSubRedDotShowTypeNewContent;
                    }
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
            NSLog(@"BNBlibliGetAuthorInfoCGI 请求失败---%@", error);
            if (self.failBlock) {
                self.failBlock(BNNetWorkErrTypeFail);
            }
        }];
    }];
}

@end
