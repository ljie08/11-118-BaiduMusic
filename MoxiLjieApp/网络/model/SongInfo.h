//
//  SongInfo.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/25.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

//播放的歌曲信息
#import <Foundation/Foundation.h>

@interface SongInfo : NSObject

@property (nonatomic, copy) NSString *special_type;
@property (nonatomic, copy) NSString *pic_huge;
@property (nonatomic, copy) NSString *ting_uid;
@property (nonatomic, copy) NSString *pic_premium;
@property (nonatomic, assign) long havehigh;
@property (nonatomic, copy) NSString *si_proxycompany;//公司
@property (nonatomic, copy) NSString *author;//歌手
@property (nonatomic, copy) NSString *toneid;
@property (nonatomic, assign) long has_mv;
@property (nonatomic, copy) NSString *song_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *artist_id;
@property (nonatomic, copy) NSString *lrclink;
@property (nonatomic, copy) NSString *relate_status;
@property (nonatomic, assign) long learn;
@property (nonatomic, copy) NSString *pic_big;
@property (nonatomic, copy) NSString *play_type;
@property (nonatomic, copy) NSString *album_id;
@property (nonatomic, copy) NSString *pic_radio;
@property (nonatomic, copy) NSString *bitrate_fee;
@property (nonatomic, copy) NSString *song_source;
@property (nonatomic, copy) NSString *all_artist_id;
@property (nonatomic, copy) NSString *all_artist_ting_uid;
@property (nonatomic, copy) NSString *piao_id;
@property (nonatomic, assign) long charge;
@property (nonatomic, copy) NSString *copytype;
@property (nonatomic, copy) NSString *all_rate;
@property (nonatomic, copy) NSString *korean_bb_song;
@property (nonatomic, assign) long is_first_publish;
@property (nonatomic, assign) long has_mv_mobile;
@property (nonatomic, copy) NSString *album_title;
@property (nonatomic, copy) NSString *pic_small;
@property (nonatomic, copy) NSString *album_no;
@property (nonatomic, copy) NSString *resource_type_ext;
@property (nonatomic, copy) NSString *resource_type;

@end
