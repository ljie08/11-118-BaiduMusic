//
//  LynnPlayer.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/26.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioStreamer.h"

@interface LynnPlayer : NSObject <DOUAudioFile>

@property (nonatomic) NSURL *audioFileURL;

@end
