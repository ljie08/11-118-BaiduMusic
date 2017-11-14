//
//  Song.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

//排行榜、推荐
//歌曲列表
#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, copy) NSString *korean_bb_song;
@property (nonatomic, copy) NSString *author;//歌手
@property (nonatomic, copy) NSString *pic_big;
@property (nonatomic, copy) NSString *si_proxycompany;//公司
@property (nonatomic, copy) NSString *country;//国家
@property (nonatomic, assign) long charge;
@property (nonatomic, copy) NSString *piao_id;
@property (nonatomic, copy) NSString *resource_type_ext;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, assign) long havehigh;
@property (nonatomic, copy) NSString *lrclink;
@property (nonatomic, copy) NSString *pic_small;
@property (nonatomic, copy) NSString *hot;
@property (nonatomic, assign) long has_mv;
@property (nonatomic, copy) NSString *song_source;
@property (nonatomic, copy) NSString *all_artist_ting_uid;
@property (nonatomic, copy) NSString *publishtime;//时间
@property (nonatomic, copy) NSString *isnew;
@property (nonatomic, copy) NSString *has_filmtv;
@property (nonatomic, assign) long file_duration;
@property (nonatomic, copy) NSString *artist_name;
@property (nonatomic, copy) NSString *toneid;
@property (nonatomic, copy) NSString *artist_id;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *album_id;
@property (nonatomic, assign) long learn;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *del_status;
@property (nonatomic, copy) NSString *album_title;
@property (nonatomic, copy) NSString *mv_provider;
@property (nonatomic, copy) NSString *album_no;
@property (nonatomic, assign) long has_mv_mobile;
@property (nonatomic, copy) NSString *song_id;
@property (nonatomic, copy) NSString *bitrate_fee;
@property (nonatomic, copy) NSString *resource_type;
@property (nonatomic, assign) long is_first_publish;
@property (nonatomic, copy) NSString *all_rate;
@property (nonatomic, copy) NSString *ting_uid;
@property (nonatomic, copy) NSString *all_artist_id;
@property (nonatomic, copy) NSString *biaoshi;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *copytype;
@property (nonatomic, copy) NSString *versions;
@property (nonatomic, copy) NSString *relate_status;

//歌手的歌曲列表
@property (nonatomic, copy) NSString *listen_total;

@end
