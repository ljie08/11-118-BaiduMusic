//
//  RecommendViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface RecommendViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *recommendList;

@property (nonatomic, assign) int page;

/**
 请求数据
 
 @param isRefresh 是否刷新
 @param success 成功
 @param failture 失败
 */
- (void)getRecommandSongListWithRefresh:(BOOL)isRefresh success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
