//
//  WebManager.m
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "WebManager.h"

@implementation WebManager

+ (instancetype)sharedManager {
    static WebManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://httpbin.org/"]];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 5;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

#pragma mark - Data

//首页 获取列表
//type = 1-新歌榜,2-热歌榜,11-摇滚榜,12-爵士,16-流行,21-欧美金曲榜,22-经典老歌榜,23-情歌对唱榜,24-影视金曲榜,25-网络歌曲榜
- (void)getBillBoardListWithType:(NSInteger)type size:(int)size offset:(int)offset success:(void(^)(NSArray *boardList))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:BillboardURL forKey:@"method"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@(offset) forKey:@"offset"];
    
    [self requestWithMethod:GET WithUrl:BaseURL WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        
        NSMutableArray *songList = [NSMutableArray array];
        songList = [Song mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"song_list"]];
        
        success(songList);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//搜索
- (void)searchWithQuery:(NSString *)query success:(void(^)(NSArray *songList, NSArray *albumList, NSArray *artistList))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:SearchURL forKey:@"method"];
    [params setObject:query forKey:@"query"];
    
    [self requestWithMethod:GET WithUrl:BaseURL WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *songArr = [NSArray array];
        songArr = [SearchSong mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"song"]];
        
        NSArray *albumArr = [NSArray array];
        albumArr = [SearchAlbum mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"album"]];
        
        NSArray *artistArr = [NSArray array];
        artistArr = [SearchArtist mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"artist"]];
        
        success(songArr, albumArr, artistArr);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//播放信息
- (void)getSongPlayDataWithId:(NSString *)songId success:(void(^)(SongInfo *songinfo, Bitrate *bitrate))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:PlayURL forKey:@"method"];
    [params setObject:songId forKey:@"songid"];
    
    [self requestWithMethod:GET WithUrl:BaseURL WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        SongInfo *song = [SongInfo mj_objectWithKeyValues:[dic objectForKey:@"songinfo"]];
        Bitrate *bitrate = [Bitrate mj_objectWithKeyValues:[dic objectForKey:@"bitrate"]];
        
        success(song, bitrate);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//歌词
- (void)getSongLryWithSongId:(NSString *)songid success:(void(^)(LrcContent *lrc))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:LryURL forKey:@"method"];
    [params setObject:songid forKey:@"songid"];
    
    [self requestWithMethod:GET WithUrl:BaseURL WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        LrcContent *lrc = [LrcContent mj_objectWithKeyValues:dic];
        success(lrc);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//推荐列表
- (void)getRecommandSongListWithSongId:(NSString *)songid num:(int)num success:(void(^)(NSArray *recommandList))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:RecommandSongURL forKey:@"method"];
    [params setObject:songid forKey:@"songid"];
    [params setObject:[NSNumber numberWithInt:num] forKey:@"num"];
    
    [self requestWithMethod:GET WithUrl:BaseURL WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *result = [dic objectForKey:@"result"];
        NSArray *recommandArr = [NSArray array];
        recommandArr = [Song mj_objectArrayWithKeyValuesArray:[result objectForKey:@"list"]];
        
        success(recommandArr);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//歌手信息
- (void)getArtistInfoWithTingUId:(NSString *)tinguid success:(void(^)(ArtistInfo *artist))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ArtistURL forKey:@"method"];
    [params setObject:tinguid forKey:@"tinguid"];
    
    [self requestWithMethod:GET WithUrl:BaseURL WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        ArtistInfo *artist = [ArtistInfo mj_objectWithKeyValues:dic];
        
        success(artist);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//歌手歌曲列表
- (void)getArtistSongListWithTingUId:(NSString *)tinguid limits:(int)limits success:(void(^)(NSArray *songList))success failure:(void(^)(NSString *errorStr))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ArtisSongListURL forKey:@"method"];
    [params setObject:[NSNumber numberWithInt:limits] forKey:@"limits"];
    [params setObject:tinguid forKey:@"tinguid"];
    
    [self requestWithMethod:GET WithUrl:BaseURL WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *songlist = [NSArray array];
        songlist = [Song mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"songlist"]];
        
        success(songlist);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark ----
#pragma mark - request
- (void)requestWithMethod:(HTTPMethod)method
                  WithUrl:(NSString *)url
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
         WithFailureBlock:(requestFailureBlock)failure {
    
    NSLog(@"url --> %@", url);
    
    switch (method) {
        case GET:{
            [self GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);

                failure(error);
            }];
            break;
        }
        case POST:{
            [self POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);

                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}

@end
