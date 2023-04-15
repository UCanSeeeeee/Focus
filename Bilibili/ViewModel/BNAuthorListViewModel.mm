//
//  BNAuthorListViewModel.m
//  BNSubscribeHelperProject
//
//  Created by blinblin on 2022/3/27.
//

#import "BNAuthorListViewModel.h"
#import "BNAuthorDataInfo.h"

@interface BNAuthorListViewModel ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<BNAuthorDataInfo *> *> *dataDic;

@end

@implementation BNAuthorListViewModel

- (NSMutableDictionary<NSNumber *,NSMutableArray<BNAuthorDataInfo *> *> *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (NSInteger)numberOfSections {
    return BNSearchAuthorSectionTypeCount - 1;
}

- (NSInteger)numberOfRowsAtSection:(NSInteger)section {
    section += 1;
    NSMutableArray<BNAuthorDataInfo *> *dataArray = [self.dataDic objectForKey:[NSNumber numberWithInteger:section]];
    return dataArray.count;
}

- (NSString *)sectionHeaderTitle:(NSInteger)section {
    section += 1;
    NSString *title = @"";
    switch (section) {
        case BNSearchAuthorSectionTypeSubscribeList:
            title = @"你订阅了ta的关注列表";
            break;
        case BNSearchAuthorSectionTypeBlibliHot: {
            title = @"B站阿婆主热榜";
        } break;
        default:
            break;
    }
    return title;
}

- (BNAuthorDataInfo *)getAuthorDataInfoAtSection:(NSInteger)section index:(NSInteger)index {
    section += 1;
    NSMutableArray<BNAuthorDataInfo *> *dataArray = [self.dataDic objectForKey:[NSNumber numberWithInteger:section]];
    return [dataArray objectAtIndex:index];
}

@end
