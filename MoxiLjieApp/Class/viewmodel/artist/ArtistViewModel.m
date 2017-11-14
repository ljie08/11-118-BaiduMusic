//
//  ArtistViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "ArtistViewModel.h"

@implementation ArtistViewModel

- (instancetype)init {
    if (self = [super init]) {
        _artistInfo = [[ArtistInfo alloc] init];
        _songList = [NSMutableArray array];
        _page = 10;
    }
    return self;
}

//获取歌手信息
- (void)getArtistDataWithID:(NSString *)tingID success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] getArtistInfoWithTingUId:tingID success:^(ArtistInfo *artist) {
        weakSelf.artistInfo = artist;
        
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

//获取歌手的歌曲列表
- (void)getSongListWithRefresh:(BOOL)isRefresh tingid:(NSString *)tingid success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    if (isRefresh) {
        self.page = 10;
    } else {
        self.page += 10;
    }
    
    @weakSelf(self);
    [[WebManager sharedManager] getArtistSongListWithTingUId:tingid limits:self.page success:^(NSArray *songList) {
        if (weakSelf.songList.count) {
            [weakSelf.songList removeAllObjects];
        }
        [weakSelf.songList addObjectsFromArray:songList];
        
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
