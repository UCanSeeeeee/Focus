//
//  WJBlockTypedefHelper.h
//  Swift - Netflix
//
//  Created by 王杰 on 2023/6/25.
//

#ifndef WJBlockTypedefHelper_h
#define WJBlockTypedefHelper_h

@class BNAuthorDataInfo;

typedef void (^BNCommonCGIFailBlock)(int errCode);

typedef void (^BNBliBliSearchAuthorSucBlock)(NSMutableArray<BNAuthorDataInfo *> *authorInfoArray);

typedef void (^BNBliBliGetAuthorInfoSucBlock)(NSMutableArray<BNAuthorDataInfo *> *authorInfo);

typedef void (^BNYoutubeSearchAuthorSucBlock)(NSMutableArray<BNAuthorDataInfo *> *authorInfoArray);
typedef void (^BNYoutubeGetAuthorInfoSucBlock)(NSMutableArray<BNAuthorDataInfo *> *authorInfo);

#endif /* WJBlockTypedefHelper_h */
