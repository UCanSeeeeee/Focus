//
//  BNSubscribeWCDB.m
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/27.
//

#import "BNSubscribeWCDB.h"
#import "BNAuthorDataInfo.h"
#import "BNSubscribeInfoModel.h"

#define kDataBaseFileName @"myWCDB.sqlite"

static NSString *const BNSubscribeAuthorInfoTableName = @"subscribeAuthorInfoTableName";
static NSString *const BNSubscribeInfoTableName = @"subscribeInfoTableName";

@interface BNSubscribeWCDB ()

@property (nonatomic, strong) WCTDatabase *dataBase;
@property (strong, nonatomic) WCTTable *authorInfoTable; // BNAuthorDataInfo
@property (strong, nonatomic) WCTTable *subscribeInfoTable; // BNSubscribeInfoModel

@end

@implementation BNSubscribeWCDB

- (instancetype)init {
    if (self = [super init]) {
        [self setUpDatabases];
    }
    return self;
}

- (WCTTable *)createTableWithTableName:(NSString *)tableName objectClass:(Class<WCTTableCoding>)itemClass {
    BOOL ret = [self.dataBase createTableAndIndexesOfName:tableName withClass:itemClass];
    if (!ret) {
        NSLog(@"create table %@ fail!", tableName);
        return nil;
    }
    
    WCTTable *table = [self.dataBase getTableOfName:tableName withClass:itemClass];
    if (!table) {
        NSLog(@"table %@ is nil!", tableName);
        return nil;
    }
    return table;
}

- (void)setUpDatabases {
    [self createDataBase];
    [self createAuthorInfoTable];
    [self createSubscribeInfoTable];
}

- (void)createDataBase{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingString:kDataBaseFileName];
    self.dataBase = [[WCTDatabase alloc] initWithPath:dbPath];
}

- (BOOL)createAuthorInfoTable {
    self.authorInfoTable = nil;
    self.authorInfoTable = [self createTableWithTableName:BNSubscribeAuthorInfoTableName objectClass:BNAuthorDataInfo.class];
    return (self.authorInfoTable != nil);
}

- (BOOL)createSubscribeInfoTable {
    self.subscribeInfoTable = nil;
    self.subscribeInfoTable = [self createTableWithTableName:BNSubscribeInfoTableName objectClass:BNSubscribeInfoModel.class];
    return (self.subscribeInfoTable != nil);
}

- (BOOL)insertOrReplaceAuthorInfos:(NSArray<BNAuthorDataInfo *> *)authorInfos {
    [authorInfos enumerateObjectsUsingBlock:^(BNAuthorDataInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cacheTime = [[NSDate date] timeIntervalSince1970];
    }];
    BOOL ret = [self.authorInfoTable insertOrReplaceObjects:authorInfos];
    return ret;
}

- (BNAuthorDataInfo *)getAuthorInfoByUsername:(NSString *)username {
    BNAuthorDataInfo *authorInfo =
    [self.authorInfoTable getOneObjectWhere:BNAuthorDataInfo.username == username orderBy:BNAuthorDataInfo.cacheTime.order()];
    
    return authorInfo;
}

- (BOOL)insertOrReplaceSubscribeInfos:(NSArray<BNSubscribeInfoModel *> *)subscribeInfos {
    BOOL ret = [self.subscribeInfoTable insertOrReplaceObjects:subscribeInfos];
    return ret;
}

- (BNSubscribeInfoModel *)getSubscribeInfoByUsername:(NSString *)username {
    BNSubscribeInfoModel *subscribeInfo = [self.subscribeInfoTable getOneObjectWhere:BNSubscribeInfoModel.username == username];
    return subscribeInfo;
}

- (NSArray<BNAuthorDataInfo *> *)getSubscribeInfoBySubscribeType:(BNSubscribeType)subscribeType platform:(BNSubAuthorPlatformType)platform {
    NSArray<BNSubscribeInfoModel *> *subscribeInfos = [self.subscribeInfoTable getObjectsWhere:BNSubscribeInfoModel.subscribeType == subscribeType];
    NSMutableArray<BNAuthorDataInfo *> *authorInfoArray = [NSMutableArray array];
    [subscribeInfos enumerateObjectsUsingBlock:^(BNSubscribeInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BNAuthorDataInfo *dataInfo = [self getAuthorInfoByUsername:obj.username];
        if (dataInfo && dataInfo.platformType == platform) {
            [authorInfoArray addObject:dataInfo];
        }
    }];
    
    // BNAuthorDataInfo 实现方法 comparePublishTime:
    NSArray *resultOrderArray = [authorInfoArray sortedArrayUsingSelector:@selector(comparePublishTime:)];
    NSMutableArray *newContentArray = [NSMutableArray array];
    [resultOrderArray enumerateObjectsUsingBlock:^(BNAuthorDataInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.redDotShowType != BNSubRedDotShowTypeNone) {
            [newContentArray addObject:obj];
        }
    }];
    NSMutableArray *nonContentArray = [NSMutableArray array];
    [resultOrderArray enumerateObjectsUsingBlock:^(BNAuthorDataInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.redDotShowType == BNSubRedDotShowTypeNone) {
            [nonContentArray addObject:obj];
        }
    }];
    [newContentArray addObjectsFromArray:nonContentArray];
    return newContentArray;
}

- (BOOL)deleteSubscribeAuthor:(NSString *)username {
    BOOL ret = [self.subscribeInfoTable deleteObjectsWhere:BNSubscribeInfoModel.username == username];
    if (ret) {
        [self.authorInfoTable deleteObjectsWhere:BNAuthorDataInfo.username == username];
    }
    return ret;
}

- (BOOL)disposeSubscribeAuthor:(NSString *)username {
    BNAuthorDataInfo *dataInfo = [self getAuthorInfoByUsername:username];
    dataInfo.redDotShowType = BNSubRedDotShowTypeNone;
    return [self insertOrReplaceAuthorInfos:@[dataInfo]];
}

@end
