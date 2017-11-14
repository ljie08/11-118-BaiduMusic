//
//  LLRefreshCollectionView.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/28.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshCollectionViewDelegate <NSObject>
@optional
/**
 *  下拉刷新
 */
- (void)refreshCollectionViewHeader;
/**
 *  上拉加载
 */
-(void)refreshCollectionViewFooter;

@end

@interface LLRefreshCollectionView : UICollectionView

@property (nonatomic, assign) id<RefreshCollectionViewDelegate> refreshCDelegate;
@property (nonatomic, assign) BOOL isShowMore;//是否显示加载更多
@property (nonatomic, assign, setter = canRefresh:) BOOL CanRefresh;//当前表格是否需要支持刷新  支持 YES  不支持NO
@property (nonatomic, copy) NSString * lastUpdateKey;//不同tableView对应不同的刷新时间的 key

@end
