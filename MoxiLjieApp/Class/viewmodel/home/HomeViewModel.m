//
//  HomeViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        _navDic = [NSDictionary dictionaryWithObjectsAndKeys: [NSArray arrayWithObjects:@"热歌榜", @"摇滚榜", @"爵士", @"流行", @"欧美金曲榜", @"经典老歌榜", @"情歌对唱榜", @"影视金曲榜", @"网络歌曲榜", nil], @"title",[NSArray arrayWithObjects:@"2", @"11", @"12", @"16", @"21", @"22", @"23", @"24", @"25", nil], @"type", nil];
        _homeList = [NSMutableArray array];
        _page = 10;
    }
    return self;
}

/**
 请求数据
 
 @param isRefresh 是否刷新
 @param type 类型 主页的slidernavbar点击的按钮对应相应的接口 默认显示最新的数据
 @param success 成功
 @param failture 失败
 */
- (void)getSongListWithRefresh:(BOOL)isRefresh type:(NSInteger)type success:(void(^)(BOOL result))success failture:(void (^)(NSString *))failture {
    if (isRefresh) {
        self.page = 10;
    } else {
        self.page += 10;
    }
    
    @weakSelf(self);
    [[WebManager sharedManager] getBillBoardListWithType:type size:self.page offset:0 success:^(NSArray *boardList) {
        if (weakSelf.homeList.count) {
            [weakSelf.homeList removeAllObjects];
        }
        [weakSelf.homeList addObjectsFromArray:boardList];
        
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
