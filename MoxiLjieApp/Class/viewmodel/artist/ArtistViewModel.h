//
//  ArtistViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface ArtistViewModel : BaseViewModel

@property (nonatomic, strong) ArtistInfo *artistInfo;
@property (nonatomic, strong) NSMutableArray *songList;

@property (nonatomic, assign) int page;

//获取歌手信息
- (void)getArtistDataWithID:(NSString *)tingID success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

//获取歌手的歌曲列表
- (void)getSongListWithRefresh:(BOOL)isRefresh tingid:(NSString *)tingid success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
