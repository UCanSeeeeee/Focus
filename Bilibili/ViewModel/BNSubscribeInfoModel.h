//
//  BNSubscribeInfoModel.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/27.
//

#import <Foundation/Foundation.h>
#import "MMUIView.h"
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
