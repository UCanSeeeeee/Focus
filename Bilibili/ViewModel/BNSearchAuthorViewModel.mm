//
//  BNSearchAuthorViewModel.m
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/3/27.
//

#import "BNSearchAuthorViewModel.h"
#import "BNAuthorDataInfo.h"
#import "BNUIBuildHelper.h"

@interface BNSearchAuthorViewModel ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<BNAuthorDataInfo *> *> *dataDic;

@end

@implementation BNSearchAuthorViewModel

- (NSMutableDictionary<NSString *,NSMutableArray<BNAuthorDataInfo *> *> *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (NSInteger)numberOfSections {
    return BNSubAuthorPlatformTypeCount - 1;
}

- (NSInteger)numberOfRowsAtSection:(NSInteger)section {
    section += 1;
    NSMutableArray<BNAuthorDataInfo *> *dataArray = [self.dataDic objectForKey:[NSString stringWithFormat:@"%lu",section]];
    return dataArray.count;
}

- (NSString *)sectionHeaderTitle:(NSInteger)section {
    section += 1;
    NSString *title = @"";
    switch (section) {
        case BNSubAuthorPlatformTypeBliBli:
            title = @"Bilibili🍻";
            break;
        case BNSubAuthorPlatformTypeYouTube: {
            title = @"Youtube👀";
        } break;
        default:
            break;
    }
    return title;
}

- (BNAuthorDataInfo *)getAuthorDataInfoAtSection:(NSInteger)section index:(NSInteger)index {
    section += 1;
    NSMutableArray<BNAuthorDataInfo *> *dataArray = [self.dataDic objectForKey:[NSString stringWithFormat:@"%lu",section]];
    return [dataArray objectAtIndex:index];
}

- (void)requestSearchAuthorByName:(NSString *)name {
    [self.dataDic removeAllObjects];
    [[BNBasicDataService shareInstance] requestBlibliSearchAuthor:name sucBlock:^(NSMutableArray<BNAuthorDataInfo *> *authorInfoArray) {
        [self.dataDic setValue:authorInfoArray forKey:[NSString stringWithFormat:@"%lu",BNSubAuthorPlatformTypeBliBli]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchAuthorDataSuc)]) {
            [self.delegate searchAuthorDataSuc];
        }
    } failBlock:^(int errCode) {
    }];
    
    [[BNBasicDataService shareInstance] requestYoutubeSearchContent:name sucBlock:^(NSMutableArray<BNAuthorDataInfo *> *authorInfoArray) {
        [self.dataDic setValue:authorInfoArray forKey:[NSString stringWithFormat:@"%lu",BNSubAuthorPlatformTypeYouTube]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchAuthorDataSuc)]) {
            [self.delegate searchAuthorDataSuc];
        }
    } failBlock:^(int errCode) {
        
    }];
}

@end
