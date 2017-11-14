//
//  RecommendViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "RecommendViewModel.h"

@implementation RecommendViewModel

- (instancetype)init {
    if (self = [super init]) {
        _recommendList = [NSMutableArray array];
        _page = 10;
    }
    return self;
}

/**
 请求数据
 
 @param isRefresh 是否刷新
 @param success 成功
 @param failture 失败
 */
- (void)getRecommandSongListWithRefresh:(BOOL)isRefresh success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    if (isRefresh) {
        self.page = 10;
    } else {
        self.page += 10;
    }
    
    @weakSelf(self);
    [[WebManager sharedManager] getBillBoardListWithType:1 size:self.page offset:0 success:^(NSArray *boardList) {
        if (weakSelf.recommendList.count) {
            [weakSelf.recommendList removeAllObjects];
        }
        [weakSelf.recommendList addObjectsFromArray:boardList];
        
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
