//
//  SearchViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/25.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "SearchViewModel.h"

@implementation SearchViewModel

- (instancetype)init {
    if (self = [super init]) {
        _songList = [NSMutableArray array];
        _albumList = [NSMutableArray array];
        _artistList = [NSMutableArray array];
        _searchList = [NSMutableArray array];
    }
    return self;
}

/**
 搜索
 
 @param seachText 搜索内容
 @param success 成功
 @param failture 失败
 */
- (void)searchSongWithString:(NSString *)seachText success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] searchWithQuery:seachText success:^(NSArray *songList, NSArray *albumList, NSArray *artistList) {
        if (weakSelf.songList.count) {
            [weakSelf.songList removeAllObjects];
        }
        [weakSelf.songList addObjectsFromArray:songList];
        
        if (weakSelf.albumList.count) {
            [weakSelf.albumList removeAllObjects];
        }
        [weakSelf.albumList addObjectsFromArray:albumList];
        
        if (weakSelf.artistList.count) {
            [weakSelf.artistList removeAllObjects];
        }
        [weakSelf.artistList addObjectsFromArray:artistList];
        
        if (weakSelf.songList.count) {
            [weakSelf.searchList addObject:weakSelf.songList];
        }
        if (weakSelf.albumList.count) {
            [weakSelf.searchList addObject:weakSelf.albumList];
        }
        if (weakSelf.artistList.count) {
            [weakSelf.searchList addObject:weakSelf.artistList];
        }
        
        if (weakSelf.songList.count || weakSelf.albumList.count || weakSelf.artistList.count) {
            success(YES);
        }
        
        if (!weakSelf.songList.count && !weakSelf.albumList.count && !weakSelf.artistList.count) {
            if (weakSelf.searchList.count) {
                [weakSelf.searchList removeAllObjects];
            }
            success(NO);
        }
        
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
