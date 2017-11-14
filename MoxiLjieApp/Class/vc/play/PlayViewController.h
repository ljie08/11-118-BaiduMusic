//
//  PlayViewController.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewController.h"
#import "LynnPlayer.h"

@interface PlayViewController : BaseViewController

@property (nonatomic, strong) NSString *songid;

@property (nonatomic,strong) LynnPlayer *file;
@property (nonatomic,assign) NSInteger type;

+ (instancetype)shareSongPlay;

- (void)setSongPlayWithID:(NSString *)songID;

@end
