//
//  SearchSong.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/25.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

//歌曲搜索结果
#import <Foundation/Foundation.h>

@interface SearchSong : NSObject

@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *songname;
@property (nonatomic, copy) NSString *songid;
@property (nonatomic, copy) NSString *has_mv;
@property (nonatomic, copy) NSString *yyr_artist;
@property (nonatomic, copy) NSString *resource_type_ext;
@property (nonatomic, copy) NSString *artistname;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *resource_provider;
@property (nonatomic, copy) NSString *control;
@property (nonatomic, copy) NSString *encrypted_songid;

@end
