//
//  BNSubscribeInfoModel.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/27.
//

#import "BNSubscribeInfoModel.h"

@implementation BNSubscribeInfoModel
WCDB_IMPLEMENTATION(BNSubscribeInfoModel)    //该宏实现绑定到表
WCDB_SYNTHESIZE(BNSubscribeInfoModel,username)
WCDB_SYNTHESIZE(BNSubscribeInfoModel,subscribeType)
WCDB_PRIMARY(BNSubscribeInfoModel, username)

- (instancetype)initWithUsername:(NSString *)username
                   subscribeType:(BNSubscribeType)subscribeType {
    if (self = [super init]) {
        self.username = username;
        self.subscribeType = subscribeType;
    }
    return self;
}

@end
