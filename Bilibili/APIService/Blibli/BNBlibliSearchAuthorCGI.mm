//
//  BNBlibliSearchAuthorCGI.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNBlibliSearchAuthorCGI.h"
#import <AFNetworking.h>
#import "BNCommonDataTool.h"
#import "BNSubDataDefine.h"
#import "BNAuthorDataInfo.h"

#define BNBlibliSearchAuthorAPI @"https://api.bilibili.com/x/web-interface/search/type?page=1&page_size=5&search_type=bili_user&order_sort=0&user_type=0"

@interface BNBlibliSearchAuthorCGI ()

@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) BNBliBliSearchAuthorSucBlock sucBlock;
@property (nonatomic, copy) BNCommonCGIFailBlock failBlock;

@end

@implementation BNBlibliSearchAuthorCGI

- (instancetype)initWithAuthorName:(NSString *)authorName
                          sucBlock:(BNBliBliSearchAuthorSucBlock)sucBlock
                         failBlock:(BNCommonCGIFailBlock)failBlock {
    if (self = [super init]) {
        self.authorName = authorName;
        self.sucBlock = sucBlock;
        self.failBlock = failBlock;
    }
    return self;
}

- (void)start {
    AFHTTPSessionManager *getManager = [AFHTTPSessionManager manager];
    //get cookie
    NSString *getUrl = @"https://bilibili.com";
    [getManager GET:getUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *requestUrl = [NSString stringWithFormat:@"%@&keyword=%@",BNBlibliSearchAuthorAPI,self.authorName];
    //把请求头进行 UTF-8编码
    NSString *path = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"BNBlibliSearchAuthorCGI 请求成功---%@", responseObject);
        NSMutableArray<BNAuthorDataInfo *> *infoArray = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *result = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    BNAuthorDataInfo *info = [BNAuthorDataInfo converFromNetResponseDic:(NSDictionary *)obj];
                    info.platformType = BNSubAuthorPlatformTypeBliBli;
                    [infoArray addObject:info];
                }
            }];
        }
        if (infoArray.count > 0) {
            self.sucBlock(infoArray);
        }else{
            self.failBlock(BNNetWorkErrTypeNone);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"BNBlibliSearchAuthorCGI 请求失败---%@", error);
        if (self.failBlock) {
            self.failBlock(BNNetWorkErrTypeFail);
        }
    }];
}

@end
