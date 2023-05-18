//
//  BNBasicDataService.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import "BNBasicDataService.h"
#import "BNBlibliSearchAuthorCGI.h"
#import "BNSubscribeWCDB.h"
#import "BNBlibliGetAuthorInfoCGI.h"
#import "BNYoutubeSearchAuthorCGI.h"
#import "BNYoutubeGetAuthorInfoCGI.h"
#import "BNSubscribeMMKV.h"

@interface BNBasicDataService ()

@property (nonatomic, strong) BNSubscribeWCDB *dataBase;
@property (nonatomic, strong) BNSubscribeMMKV *mmkvModel;
@property (nonatomic, strong) NSMutableArray *youtubeKeySecretArray;

@end

@implementation BNBasicDataService

+ (instancetype)shareInstance{
    static BNBasicDataService *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[super allocWithZone:NULL] init];
    });
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareInstance];
}

- (id)copy{
    return self;
}

- (id)mutableCopy{
    return self;
}

- (NSMutableArray *)youtubeKeySecretArray {
    if (!_youtubeKeySecretArray) {
        _youtubeKeySecretArray = [NSMutableArray array];
        [_youtubeKeySecretArray addObject:@"AIzaSyCvTt_60ZQA6o4OqmDHDJiKHUUV76PKTBA"]; // chieht
        [_youtubeKeySecretArray addObject:@"AIzaSyDvbffT9BuSDVBRrYaN1R8ghOaI6DRfYSo"]; // binbinw476
        [_youtubeKeySecretArray addObject:@"AIzaSyAjRgCSkz4sjee9xWf3Bdc21-6Js98judU"]; // binbinw01@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyDYf12TL8xkHeo7A26S8k6YvUQ3q8o5vYw"]; // binbinw04@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyCoI3xVmVzk2cqxyfeDljCxGBHgozlx2qU"]; // binbinw353@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyDGOsl4UrqBAEhA5fE_YduUVFGbFEgoq-k"]; // binbinw495@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyBJ9QLAZh0tJGFn5ZmHqBWDUMjT9o3CN2g"]; // ariyrumki2@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyC_F1Gd4i4NAlNT35X0GWugt7qu3yy8b_k"]; // rekhiyshumila@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyCOwWYNLhzGSK3lS9hzBwZq_S7NH299X84"]; // sheshiytanjima@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyAMZo0aTBF43KaES4UoUD95UvfvqEvMReU"]; // shumiylimiy@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyDy1O48GFoftnlwk6Xw3L1IgLkiWkABHEw"]; // limiyariy1@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyDsxOSKkyoSZx5GMvPWloB2rgFC2UJIrwU"]; // ariyerina7@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyDuQjaNsit-qu30yGWOFRWUvAp2AK8PF0Y"]; // shumaariy@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyDE-u8pC0F9yzOjqN9WGCB6MHDF79z5k24"]; // lemashumi5@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyAhLt0FJz3YCIP2TvcnnZCWR4vvc_ybjKA"]; // lamiyshuma948@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyBBQaGObbvz_JWbiGorK_4su_YDVHkItxs"]; // shimalamiy4@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyCU1PoYsxLV1Z54NlPAgnvpn9xavRxUE0w"]; // tachlimashuma@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyA0TxjGVfK8P7_6r9NSJusz0LjM2plRlRQ"]; // niliyshuma87@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyADhv55LezmXf77VS44_1FePzMd9da_Ko8"]; // shuma7135@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyBx8oTTKLkkVJIkUNrTjp2CvMp_tsMOHrs"]; // remiyduli23@gmail.com
        [_youtubeKeySecretArray addObject:@"AIzaSyC9g0OiJZGmToNEZ814mCr55IJfb9I5HeU"]; // nilimashuma43@gmail.com
    }
    return _youtubeKeySecretArray;
}

- (BNSubscribeWCDB *)dataBase {
    if (!_dataBase) {
        _dataBase = [[BNSubscribeWCDB alloc] init];
    }
    return _dataBase;
}

- (BNSubscribeMMKV *)mmkvModel {
    if (!_mmkvModel) {
        _mmkvModel = [[BNSubscribeMMKV alloc] init];
    }
    return _mmkvModel;
}

#pragma mark - WCDB
- (BNSubscribeInfoModel *)getSubscribeInfoByUsername:(NSString *)username {
    return [self.dataBase getSubscribeInfoByUsername:username];
}

#pragma mark - Blibli
- (void)requestBlibliSearchAuthor:(NSString *)author
                         sucBlock:(BNBliBliSearchAuthorSucBlock)sucBlock
                        failBlock:(BNCommonCGIFailBlock)failBlock {
    BNBlibliSearchAuthorCGI *cgi = [[BNBlibliSearchAuthorCGI alloc] initWithAuthorName:author sucBlock:^(NSMutableArray<BNAuthorDataInfo *> *authorInfoArray) {
        [self.dataBase insertOrReplaceAuthorInfos:authorInfoArray];
        if (sucBlock) {
            sucBlock(authorInfoArray);
        }
    } failBlock:^(int errCode) {
        if (failBlock) {
            failBlock(errCode);
        }
    }];
    [cgi start];
}

- (void)requestBlibliAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
                        sucBlock:(BNBliBliGetAuthorInfoSucBlock)sucBlock
                       failBlock:(BNCommonCGIFailBlock)failBlock {
    BNBlibliGetAuthorInfoCGI *cgi = [[BNBlibliGetAuthorInfoCGI alloc] initWithAuthorInfos:authorDataArray sucBlock:^(NSMutableArray<BNAuthorDataInfo *> *authorInfo) {
        [self.dataBase insertOrReplaceAuthorInfos:authorInfo];
        if (sucBlock) {
            sucBlock(authorInfo);
        }
    } failBlock:^(int errCode) {
        if (failBlock) {
            failBlock(errCode);
        }
    }];
    [cgi start];
}

#pragma mark - Youtube
- (void)requestYoutubeSearchContent:(NSString *)searchContent
                           sucBlock:(BNYoutubeSearchAuthorSucBlock)sucBlock
                          failBlock:(BNCommonCGIFailBlock)failBlock {
    BNYoutubeSearchAuthorCGI *searchCGI = [[BNYoutubeSearchAuthorCGI alloc] initWithSearchContent:searchContent sucBlock:^(NSMutableArray<BNAuthorDataInfo *> *authorInfoArray) {
        [self.dataBase insertOrReplaceAuthorInfos:authorInfoArray];
        if (sucBlock) {
            sucBlock(authorInfoArray);
        }
    } failBlock:^(int errCode) {
        if (failBlock) {
            failBlock(errCode);
        }
    }];
    [searchCGI start];
}

- (void)requestYoutubeAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
                         sucBlock:(BNYoutubeGetAuthorInfoSucBlock)sucBlock
                        failBlock:(BNCommonCGIFailBlock)failBlock {
    BNYoutubeGetAuthorInfoCGI *cgi = [[BNYoutubeGetAuthorInfoCGI alloc] initWithAuthorInfos:authorDataArray sucBlock:^(NSMutableArray<BNAuthorDataInfo *> *authorInfo) {
        [self.dataBase insertOrReplaceAuthorInfos:authorInfo];
        if (sucBlock) {
            sucBlock(authorInfo);
        }
    } failBlock:^(int errCode) {
        if (failBlock) {
            failBlock(errCode);
        }
    }];
    
    [cgi start];
}

- (void)requestAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorDataArray
              platFormType:(BNSubAuthorPlatformType)platFormType
                  sucBlock:(BNYoutubeGetAuthorInfoSucBlock)sucBlock
                 failBlock:(BNCommonCGIFailBlock)failBlock {
    switch (platFormType) {
        case BNSubAuthorPlatformTypeBliBli:
        {
            [self requestBlibliAuthorInfos:authorDataArray sucBlock:^(NSMutableArray<BNAuthorDataInfo *> *authorInfo) {
                if (sucBlock) {
                    sucBlock(authorInfo);
                }
            } failBlock:^(int errCode) {
                if (failBlock) {
                    failBlock(errCode);
                }
            }];
        }
            break;
        case BNSubAuthorPlatformTypeYouTube:
        {
            [self requestYoutubeAuthorInfos:authorDataArray sucBlock:^(NSMutableArray<BNAuthorDataInfo *> *authorInfo) {
                if (sucBlock) {
                    sucBlock(authorInfo);
                }
            } failBlock:^(int errCode) {
                if (failBlock) {
                    failBlock(errCode);
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (NSString *)getRandomYoutubeKeySecret {
    NSUInteger randomIndex = arc4random() % self.youtubeKeySecretArray.count;
    return [self.youtubeKeySecretArray objectAtIndex:randomIndex];
}

@end
