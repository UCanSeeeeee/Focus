//
//  BNAuthorListViewModel.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BNAuthorDataInfo;

typedef NS_ENUM(NSUInteger, BNSearchAuthorSectionType) {
    BNSearchAuthorSectionTypeNone = 0, ///< 不展示
    BNSearchAuthorSectionTypeSubscribeList = 1, ///< 你订阅了ta的关注列表
    BNSearchAuthorSectionTypeBlibliHot = 2, ///< B站阿婆主热榜
    BNSearchAuthorSectionTypeCount
};

@interface BNAuthorListViewModel : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsAtSection:(NSInteger)section;
- (NSString *)sectionHeaderTitle:(NSInteger)section;
- (BNAuthorDataInfo *)getAuthorDataInfoAtSection:(NSInteger)section index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
