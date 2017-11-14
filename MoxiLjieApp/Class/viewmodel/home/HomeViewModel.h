//
//  HomeViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface HomeViewModel : BaseViewModel

//type = 1-新歌榜,2-热歌榜,11-摇滚榜,12-爵士,16-流行,21-欧美金曲榜,22-经典老歌榜,23-情歌对唱榜,24-影视金曲榜,25-网络歌曲榜
@property (nonatomic, strong) NSDictionary *navDic;
@property (nonatomic, strong) NSMutableArray *homeList;

@property (nonatomic, assign) int page;

/**
 请求数据
 
 @param isRefresh 是否刷新
 @param type 类型 主页的slidernavbar点击的按钮对应相应的接口 默认显示最新的数据
 @param success 成功
 @param failture 失败
 */
- (void)getSongListWithRefresh:(BOOL)isRefresh type:(NSInteger)type success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
