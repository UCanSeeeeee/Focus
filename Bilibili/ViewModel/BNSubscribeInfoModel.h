//
//  BNSubscribeInfoModel.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import <Foundation/Foundation.h>
#import "WJDefineHelper.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNSubscribeInfoModel : NSObject <WCTTableCoding>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) BNSubscribeType subscribeType;

WCDB_PROPERTY(username)
WCDB_PROPERTY(subscribeType)

- (instancetype)initWithUsername:(NSString *)username
                   subscribeType:(BNSubscribeType)subscribeType;

@end

NS_ASSUME_NONNULL_END
