//
//  WebManager.h
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface WebManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

#pragma mark - Data
//首页 获取列表
//type = 1-新歌榜,2-热歌榜,11-摇滚榜,12-爵士,16-流行,21-欧美金曲榜,22-经典老歌榜,23-情歌对唱榜,24-影视金曲榜,25-网络歌曲榜
- (void)getBillBoardListWithType:(NSInteger)type size:(int)size offset:(int)offset success:(void(^)(NSArray *boardList))success failure:(void(^)(NSString *errorStr))failure;

//搜索
- (void)searchWithQuery:(NSString *)query success:(void(^)(NSArray *songList, NSArray *albumList, NSArray *artistList))success failure:(void(^)(NSString *errorStr))failure;

//播放信息
- (void)getSongPlayDataWithId:(NSString *)songId success:(void(^)(SongInfo *songinfo, Bitrate *bitrate))success failure:(void(^)(NSString *errorStr))failure;

//歌词
- (void)getSongLryWithSongId:(NSString *)songid success:(void(^)(LrcContent *lrc))success failure:(void(^)(NSString *errorStr))failure;

//推荐列表
- (void)getRecommandSongListWithSongId:(NSString *)songid num:(int)num success:(void(^)(NSArray *recommandList))success failure:(void(^)(NSString *errorStr))failure;

//歌手信息
- (void)getArtistInfoWithTingUId:(NSString *)tinguid success:(void(^)(ArtistInfo *artist))success failure:(void(^)(NSString *errorStr))failure;

//歌手歌曲列表
- (void)getArtistSongListWithTingUId:(NSString *)tinguid limits:(int)limits success:(void(^)(NSArray *songList))success failure:(void(^)(NSString *errorStr))failure;

#pragma mark -----
#pragma mark - request
- (void)requestWithMethod:(HTTPMethod)method
                 WithUrl:(NSString *)url
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailureBlock:(requestFailureBlock)failure;

@end
