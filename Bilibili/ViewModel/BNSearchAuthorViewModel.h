//
//  BNSearchAuthorViewModel.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BNSearchAuthorViewModelDelegate <NSObject>

@optional
- (void)searchAuthorDataSuc;

@end

@class BNAuthorDataInfo;

@interface BNSearchAuthorViewModel : NSObject

@property (nonatomic, weak) id<BNSearchAuthorViewModelDelegate> delegate;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsAtSection:(NSInteger)section;
- (NSString *)sectionHeaderTitle:(NSInteger)section;
- (BNAuthorDataInfo *)getAuthorDataInfoAtSection:(NSInteger)section index:(NSInteger)index;

- (void)requestSearchAuthorByName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
