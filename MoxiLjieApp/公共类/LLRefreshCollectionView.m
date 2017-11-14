//
//  LLRefreshCollectionView.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/28.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "LLRefreshCollectionView.h"

@implementation LLRefreshCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    return self;
}

- (void)setLastUpdateKey:(NSString *)lastUpdateKey {
    self.mj_header.lastUpdatedTimeKey = [NSString stringWithFormat:@"%@__updateTimeKey",lastUpdateKey];
}

- (void)setRefreshDelegate:(id)refreshCDelegate {
    _refreshCDelegate = refreshCDelegate;
    self.delegate = refreshCDelegate;
    self.dataSource = refreshCDelegate;
}

- (void)canRefresh:(BOOL)CanRefresh {
    _CanRefresh = CanRefresh;
    
    if (!CanRefresh) {
        self.mj_header = nil;
        self.mj_footer = nil;
    } else {
        __weak typeof (self)wself = self;
        
        if (self.mj_header == nil) {
            
            self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                if ([wself.refreshCDelegate respondsToSelector:@selector(refreshCollectionViewHeader)]) {
                    [wself.refreshCDelegate refreshCollectionViewHeader];
                    [wself reloadData];
                    [wself.mj_header endRefreshing];
                }
            }];
        }
        if (self.mj_footer == nil) {
            self.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                if ([wself.refreshCDelegate respondsToSelector:@selector(refreshCollectionViewFooter)]) {
                    [wself.refreshCDelegate refreshCollectionViewFooter];
                    [wself reloadData];
                    [wself.mj_footer endRefreshing];
                }
                
            }];
        }
    }
}

- (void)setIsShowMore:(BOOL)isShowMore {
    _isShowMore = isShowMore;
    self.mj_footer.hidden = !isShowMore;
}

@end
