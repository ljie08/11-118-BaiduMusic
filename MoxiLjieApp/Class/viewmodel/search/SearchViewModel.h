//
//  SearchViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/25.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface SearchViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *songList;
@property (nonatomic, strong) NSMutableArray *albumList;
@property (nonatomic, strong) NSMutableArray *artistList;

@property (nonatomic, strong) NSMutableArray *searchList;//搜索结果包含几种：歌手、歌曲、专辑

/**
 搜索

 @param seachText 搜索内容
 @param success 成功
 @param failture 失败
 */
- (void)searchSongWithString:(NSString *)seachText success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
