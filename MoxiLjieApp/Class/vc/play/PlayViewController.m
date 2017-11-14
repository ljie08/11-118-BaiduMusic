//
//  PlayViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "PlayViewController.h"
#import "DOUAudioStreamer.h"
//#import <AVFoundation/AVFoundation.h>
//#import <MediaPlayer/MediaPlayer.h>
#import "PlayViewModel.h"
#import "ArtistViewController.h"

#define ZYStatusProp @"status"

@interface PlayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgview;//背景图
@property (weak, nonatomic) IBOutlet UILabel *songnameLab;//歌曲
@property (weak, nonatomic) IBOutlet UILabel *artistLab;//歌手
@property (weak, nonatomic) IBOutlet UIImageView *abulmImgview;//专辑图片
@property (weak, nonatomic) IBOutlet UIProgressView *songProgress;//进度条
@property (weak, nonatomic) IBOutlet UILabel *playTimeLab;//播放时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;//总时间
@property (weak, nonatomic) IBOutlet UIButton *playBtn;//播放

@property (nonatomic, strong) DOUAudioStreamer *streamer;
@property (nonatomic,assign) BOOL isPlay;// 是否处于播放状态
@property (nonatomic, strong) PlayViewModel *viewmodel;

/**
 *  播放进度定时器
 */
@property (nonatomic, strong) NSTimer *currentTimeTimer;

@property (nonatomic,assign) double oldProgress;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldProgress = 0.000;
    self.isPlay = YES;
    
    self.file = [[LynnPlayer alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.playTimeLab.text = @"0:00";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGFloat width = self.abulmImgview.frame.size.width;
    self.abulmImgview.layer.masksToBounds = YES;
    self.abulmImgview.layer.cornerRadius = width/2;
    NSLog(@"...");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.songid forKey:@"songid"];
    
    NSLog(@"----%@---", self.songid);
}

+ (instancetype)shareSongPlay {
    static PlayViewController *songPlay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        songPlay = [[PlayViewController alloc] init];
    });
    return songPlay;
}

- (void)setSongPlayWithID:(NSString *)songID {
    //如果换了歌曲
    if (![self.songid isEqualToString:songID]) {
        [self resetPlayingMusic];
        self.songid = songID;
        [self loadData];
    } else {
        // 当前播放状态
        if (self.isPlay) {
            [self startPlayingMusic];
        } else {
            [self removeCurrentTimeTimer];
            self.playBtn.selected = NO;
        }
    }
}

#pragma mark - data
- (void)initViewModelBinding {
    self.viewmodel = [[PlayViewModel alloc] init];
//    [self loadData];
}

- (void)loadData {
    @weakSelf(self);
    [self showWaiting];
    [self.viewmodel getPlayDataWithID:self.songid success:^(BOOL result) {
        [weakSelf hideWaiting];
        [weakSelf setUpData];
        [weakSelf startPlayingMusic];
        
    } failture:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
}

#pragma mark - 事件
- (IBAction)playOrStop:(UIButton *)sender {
    if (self.playBtn.isSelected) { // 暂停
        self.playBtn.selected = NO;
        [self.streamer pause];
        [self removeCurrentTimeTimer];
    } else { // 继续播放
        self.playBtn.selected = YES;
        [self.streamer play];
        [self addCurrentTimeTimer];
    }
    self.isPlay = self.playBtn.selected;
}

- (void)gotoArtistVC {
    [self gotoArtistVCWithTinguid:self.viewmodel.songInfo.ting_uid];
//    ArtistInfo *info = self.viewmodel.songInfo.ting_uid;
}

- (void)goBack {
    [self removeCurrentTimeTimer];
    [super goBack];
}

#pragma mark - 音乐控制
/**
 *  重置正在播放的音乐
 */
- (void)resetPlayingMusic {
    // 1.重置界面数据
    self.bgImgview.image = nil;
    self.abulmImgview.image = nil;
    self.songnameLab.text = nil;
    self.artistLab.text = nil;
    self.totalTimeLab.text = nil;
    self.songProgress.progress = 0.0;
    self.playTimeLab.text = nil;
    
    [self.streamer removeObserver:self forKeyPath:ZYStatusProp];
    
    // 2.停止播放
    [self.streamer stop];
    self.streamer = nil;
    
    // 3.停止定时器
    [self removeCurrentTimeTimer];
    
    // 4.设置播放按钮状态
    self.playBtn.selected = NO;
}

/**
 *  开始播放音乐
 */
- (void)startPlayingMusic {
    if (self.streamer) {
        [self addCurrentTimeTimer];
        // 播放
        if (self.playBtn.selected) {
            [self.streamer play];
        } else {
            [self.streamer pause];
        }
        
        return;
    }
    
    // 1.设置界面数据
    [self setUpData];
    // 2.开始播放
    self.file.audioFileURL = [NSURL URLWithString:self.viewmodel.bitrate.file_link];
    
    // 创建播放器
    self.streamer = [DOUAudioStreamer streamerWithAudioFile:self.file];
    // KVO监听streamer的属性（Key value Observing）
    [self.streamer addObserver:self forKeyPath:ZYStatusProp options:NSKeyValueObservingOptionOld context:nil];
    
    // 播放
    if (self.playBtn.selected) {
        [self.streamer play];
    } else {
        [self.streamer pause];
    }
    
    [self addCurrentTimeTimer];
    // 设置播放按钮状态
    self.playBtn.selected = YES;
}


#pragma mark - 定时器处理
- (void)addCurrentTimeTimer {
    
    [self removeCurrentTimeTimer];
    
    // 保证定时器的工作是及时的
    [self updateTime];
    
    self.currentTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.currentTimeTimer forMode:NSRunLoopCommonModes];
}

- (void)removeCurrentTimeTimer {
    [self.currentTimeTimer invalidate];
    self.currentTimeTimer = nil;
}

/**
 *  更新播放进度
 */
- (void)updateTime {
    
    // 1.计算进度值
    double time = 1;
    if (self.viewmodel.bitrate.file_duration == 0) {
        time = 1000.0;
    } else {
        time = self.viewmodel.bitrate.file_duration;
    }
    
    double progress = self.streamer.currentTime / time;
    if (progress == self.oldProgress) {
        [self.streamer play];
        
    }
    self.oldProgress = progress;
    if (progress > 0.99) {
        [self.streamer pause];
        self.playBtn.selected = NO;
        self.songProgress.progress = progress;
        
        [self removeCurrentTimeTimer];
        progress = 0.000000;
        NSTimeInterval time = self.streamer.duration * progress;
        self.oldProgress = 0.000000;
        
        self.playTimeLab.text = [self strWithTime:time];
        self.streamer.currentTime = time;
        return;
    }
    
    self.playTimeLab.text = [self strWithTime:self.streamer.currentTime];
    self.songProgress.progress = progress;
}

#pragma mark - 私有方法
/**
 *  时长长度 -> 时间字符串
 */
- (NSString *)strWithTime:(NSTimeInterval)time {
    int minute = time / 60;
    int second = (int)time % 60;
    if (second < 10) {
        
        return [NSString stringWithFormat:@"%d:0%d", minute, second];
    } else {
        return [NSString stringWithFormat:@"%d:%d", minute, second];
    }
}

#pragma mark - 监听
/**
 利用KVO监听的属性值改变了,就会调用
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:ZYStatusProp]) { // 监听到播放器状态改变了
            
            if (self.streamer.status == DOUAudioStreamerError) {
                
                [self showMassage:@"音乐加载失败"];
            }
        }
    });
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
    
    [self setNav];
    NSLog(@"...");
}

- (void)setUpData {
//    [self initTitleViewWithTitle:self.viewmodel.songInfo.title];
    
    [self.bgImgview sd_setImageWithURL:[NSURL URLWithString:self.viewmodel.songInfo.pic_premium] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    [self.abulmImgview sd_setImageWithURL:[NSURL URLWithString:self.viewmodel.songInfo.pic_premium] placeholderImage:PlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.songnameLab.text = self.viewmodel.songInfo.title;
    self.artistLab.text = self.viewmodel.songInfo.author;
    self.playTimeLab.text = @"0:00";
    self.totalTimeLab.text = [NSString stringWithFormat:@"%ld:%ld", self.viewmodel.bitrate.file_duration/60, self.viewmodel.bitrate.file_duration%60];
}

- (void)setNav {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);

    UIImage *rightImg = [UIImage imageNamed:@"me"];
    
    rightImg = [rightImg imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
//
    [rightBtn setImage:rightImg forState:UIControlStateNormal];
    [rightBtn setTintColor:FontColor];
    
    [rightBtn addTarget:self action:@selector(gotoArtistVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self addNavigationWithTitle:nil leftItem:nil rightItem:rightItem titleView:nil];
}

#pragma mark - dealloc
- (void)dealloc {
    [self.viewmodel cancelAllHTTPRequest];
    [self.streamer removeObserver:self forKeyPath:ZYStatusProp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
