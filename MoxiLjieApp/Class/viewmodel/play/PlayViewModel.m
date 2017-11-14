//
//  PlayViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "PlayViewModel.h"

@implementation PlayViewModel

- (instancetype)init {
    if (self = [super init]) {
        _songInfo = [[SongInfo alloc] init];
        _bitrate = [[Bitrate alloc] init];
    }
    return self;
}

- (void)getPlayDataWithID:(NSString *)songID success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] getSongPlayDataWithId:songID success:^(SongInfo *songinfo, Bitrate *bitrate) {
        weakSelf.songInfo = songinfo;
        weakSelf.bitrate = bitrate;
        success(YES);
        
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
