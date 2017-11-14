//
//  Bitrate.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bitrate : NSObject

@property (nonatomic, copy) NSString *show_link;
@property (nonatomic, assign) long free;
@property (nonatomic, copy) NSString *song_file_id;
@property (nonatomic, copy) NSString *file_size;
@property (nonatomic, copy) NSString *file_extension;
@property (nonatomic, assign) long file_duration;
@property (nonatomic, assign) long file_bitrate;
@property (nonatomic, copy) NSString *file_link;

@end
