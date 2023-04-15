//
//  BNMainListViewModel.h
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TMLazyItemModel;
@class BNMainCardViewModel;

@protocol BNMainListViewModelDelegate <NSObject>


@end

@interface BNMainListViewModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *cardTypeArray;

@end

NS_ASSUME_NONNULL_END
