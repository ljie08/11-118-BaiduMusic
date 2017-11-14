//
//  PlayViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface PlayViewModel : BaseViewModel

@property (nonatomic, strong) SongInfo *songInfo;
@property (nonatomic, strong) Bitrate *bitrate;

- (void)getPlayDataWithID:(NSString *)songID success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
