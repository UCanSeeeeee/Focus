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
//        shareInstance = [[self alloc] init];
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
        [_youtubeKeySecretArray addObject:@"AIzaSyAMrm9OVPV5EVNuewBRCq8MBeM2FQ2KRzQ"]; // chieh
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
